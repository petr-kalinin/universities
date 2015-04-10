describe "Review", ->
    it "should be created with univ, cat, text, author", ->
        spyOn Reviews.collection, "insert"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue _id: "user"

        Reviews.create {_id: "univ"}, {_id: "cat"}, "text", {_id: "user"}
 
        expect(Reviews.collection.insert.calls.mostRecent().args[0]).toEqual
            university: "univ",
            category: "cat",
            text: "text",
            author: "user"
                
    it "should not be created without required fields", ->
        spyOn Reviews.collection, "insert"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue _id: "user"
                
        expect(Reviews.userCanCreate()).toBe(true)
        
        expect -> Reviews.create null, {_id: "cat"}, "text", {_id: "user"}
            .toThrow()

        expect -> Reviews.create {_id: "univ"}, null, "text", {_id: "user"}
            .toThrow()
            
        expect -> Reviews.create {_id: "univ"}, {_id: "cat"}, "", {_id: "user"}
            .toThrow()
            
        expect -> Reviews.create {_id: "univ"}, {_id: "cat"}, "text", null
            .toThrow()

        expect -> Reviews.create {_id: "univ"}, {_id: "cat"}, "text", {_id: "user2"}
            .toThrow()
            
        expect(Reviews.collection.insert).not.toHaveBeenCalled
                
    it "should not be created by non-authorized users", ->
        spyOn Reviews.collection, "insert"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue null
                
        expect(Reviews.userCanCreate()).toBe(false)
        expect -> Reviews.create {_id: "univ"}, {_id: "cat"}, "text", {_id: "user"}
            .toThrow()
            
        expect(Reviews.collection.insert).not.toHaveBeenCalled
                
    it "should be possible to find by university and category", ->
        spyOn Reviews.collection, "find"
            .and.returnValue "111"
    
        cat1 = {_id: "cat", findDescendats: -> ["abc", "def"]}
        a = Reviews.find {_id: "univ"}, cat1

        expect(a).toBe("111")
        expect(Reviews.collection.find).toHaveBeenCalledWith {
            university: "univ",
            category: {$in: ["abc", "def"]}
        }, {sort: {createdAt: 1}}
                
    it "should be possible to find all", ->
        spyOn Reviews.collection, "find"
            .and.returnValue "111"

        a = Reviews.findAll()
 
        expect(a).toBe("111")
        expect(Reviews.collection.find).toHaveBeenCalledWith {}, sort: {createdAt: -1}

    it "should be possible to find with limit", ->
        spyOn Reviews.collection, "find"
            .and.returnValue "111"

        a = Reviews.findAll(10, 1)
 
        expect(a).toBe("111")
        expect(Reviews.collection.find).toHaveBeenCalledWith {}, 
            limit:10
            sort: {createdAt: 1}

    it "should be possible to cout all", ->
        spyOn Reviews.collection, "find"
            .and.returnValue count: -> return 3

        a = Reviews.count()
 
        expect(a).toBe(3)
        expect(Reviews.collection.find).toHaveBeenCalledWith {}, sort: {createdAt: -1}
                
    it "should be possible to find by university", ->
        spyOn Reviews.collection, "find"
            .and.returnValue "111"
        spyOn Reviews.collection, "findOne"
            .and.returnValue "222"

        a = Reviews.findByUniversity {_id: "univ1"}
        b = Reviews.findOneByUniversity {_id: "univ2"}
 
        expect(a).toBe("111")
        expect(b).toBe("222")
        expect(Reviews.collection.find).toHaveBeenCalledWith {university: "univ1"}, sort: {createdAt: 1}
        expect(Reviews.collection.findOne).toHaveBeenCalledWith university: "univ2"
                
    it "should not be possible to remove for non-author", ->
        spyOn Reviews.collection, "remove"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue {_id: "user1", isAdmin: -> false}
        
        c = Reviews.collection._transform _id: "111", author: "user2"
        expect(c.canRemove()).toBe(false)
        expect(c.remove).toThrow()
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Reviews.collection.remove).not.toHaveBeenCalled()
        
    it "should not be possible to remove for non-logged-in", ->
        spyOn Reviews.collection, "remove"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue null
        
        c = Reviews.collection._transform _id: "111", author: "user2"
        expect(c.canRemove()).toBe(false)
        expect(c.remove).toThrow()
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Reviews.collection.remove).not.toHaveBeenCalled()
        
    it "should be possible to remove for author", ->
        spyOn Reviews.collection, "remove"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue _id: "user2"
        
        c = Reviews.collection._transform _id: "111", author: "user2"
        c.remove()
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Reviews.collection.remove).toHaveBeenCalledWith "111"
        
    it "should be possible to remove for admin", ->
        spyOn Reviews.collection, "remove"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue {_id: "user1", isAdmin: -> true}
        
        c = Reviews.collection._transform _id: "111", author: "user2"
        c.remove()
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Reviews.collection.remove).toHaveBeenCalledWith "111"
        
    it "should return author", ->
        spyOn Users, "findById"
            .and.returnValue "123"
        spyOn Universities, "findById"
            .and.returnValue "456"
        spyOn Categories, "findById"
            .and.returnValue "789"
        
        c = Reviews.collection._transform author: "user", category: "cat", university: "univ"
        a = c.getAuthor()
        b = c.getUniversity()
        c = c.getCategory()
            
        expect(a).toBe "123"
        expect(b).toBe "456"
        expect(c).toBe "789"
        expect(Users.findById).toHaveBeenCalledWith "user"
        expect(Universities.findById).toHaveBeenCalledWith "univ"
        expect(Categories.findById).toHaveBeenCalledWith "cat"
        
