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

        a = Reviews.find {_id: "univ"}, {_id: "cat"}

        expect(a).toBe("111")
        expect(Reviews.collection.find).toHaveBeenCalledWith
            university: "univ",
            category: "cat"
                
    it "should be possible to find all", ->
        spyOn Reviews.collection, "find"
            .and.returnValue "111"

        a = Reviews.findAll()
 
        expect(a).toBe("111")
        expect(Reviews.collection.find).toHaveBeenCalledWith {}
                
    it "should be possible to find by university", ->
        spyOn Reviews.collection, "find"
            .and.returnValue "111"
        spyOn Reviews.collection, "findOne"
            .and.returnValue "222"

        a = Reviews.findByUniversity {_id: "univ1"}
        b = Reviews.findOneByUniversity {_id: "univ2"}
 
        expect(a).toBe("111")
        expect(b).toBe("222")
        expect(Reviews.collection.find).toHaveBeenCalledWith university: "univ1"
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
        
        c = Reviews.collection._transform author: "user"
        a = c.getAuthor()
            
        expect(a).toBe "123"
        expect(Users.findById).toHaveBeenCalledWith "user"
        
