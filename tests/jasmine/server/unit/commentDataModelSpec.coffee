describe "Comment", ->
    it "should be created with review, text, author", ->
        spyOn Comments.collection, "insert"
            .and.returnValue 123 #returns is of inserted doc
        spyOn Users, "currentUser"
            .and.returnValue _id: "user"
        spyOn Notifications, "createFromComment"
            .and.returnValue true

        Comments.create {_id: "rev"}, "text", {_id: "user"}
 
        expectedDoc = 
            review: "rev",
            text: "text",
            author: "user"
    
        expect(Comments.collection.insert.calls.mostRecent().args[0]).toEqual expectedDoc
        # note that Notifications.createFromComment is given full comment, not the db entry
        expectedDoc._id = 123
        call = Notifications.createFromComment.calls.mostRecent().args[0]
        expect(call).toEqual Comments.collection._transform expectedDoc
            
                
    it "should not be created without required fields", ->
        spyOn Comments.collection, "insert"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue _id: "user"
                
        expect(Comments.userCanCreate()).toBe(true)
        
        expect -> Comments.create null, "text", {_id: "user"}
            .toThrow()

        expect -> Comments.create {_id: "univ"}, "", {_id: "user"}
            .toThrow()
            
        expect -> Comments.create {_id: "univ"}, "text", null
            .toThrow()

        expect -> Comments.create {_id: "univ"}, "text", {_id: "user2"}
            .toThrow()
            
        expect(Comments.collection.insert).not.toHaveBeenCalled()
                
    it "should not be created by non-authorized users", ->
        spyOn Comments.collection, "insert"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue null
                
        expect(Comments.userCanCreate()).toBe(false)
        expect -> Comments.create {_id: "univ"}, "text", {_id: "user"}
            .toThrow()
            
        expect(Comments.collection.insert).not.toHaveBeenCalled()
                
    it "should be possible to find by review", ->
        spyOn Comments.collection, "find"
            .and.returnValue "111"
    
        rev1 = {_id: "rev"}
        a = Comments.find rev1

        expect(a).toBe("111")
        expect(Comments.collection.find).toHaveBeenCalledWith {
            review: "rev"
        }, {sort: {createdAt: 1}}
                
    it "should be possible to find by user", ->
        spyOn Comments.collection, "find"
            .and.returnValue "111"
    
        user1 = {_id: "user"}
        a = Comments.findByUser user1

        expect(a).toBe("111")
        expect(Comments.collection.find).toHaveBeenCalledWith {
            author: "user"
        }, {sort: {createdAt: 1}}
                
    it "should be possible to find all", ->
        spyOn Comments.collection, "find"
            .and.returnValue "111"

        a = Comments.findAll()
 
        expect(a).toBe("111")
        expect(Comments.collection.find).toHaveBeenCalledWith {}, sort: {createdAt: -1}

    it "should be possible to find with limit", ->
        spyOn Comments.collection, "find"
            .and.returnValue "111"

        a = Comments.findAll(10, 1)
 
        expect(a).toBe("111")
        expect(Comments.collection.find).toHaveBeenCalledWith {}, 
            limit:10
            sort: {createdAt: 1}

    it "should be possible to count all", ->
        spyOn Comments.collection, "find"
            .and.returnValue count: -> return 3

        a = Comments.count()
 
        expect(a).toBe(3)
        expect(Comments.collection.find).toHaveBeenCalledWith {}, sort: {createdAt: -1}
                
    it "should not be possible to remove for non-author", ->
        spyOn Comments.collection, "remove"
            .and.returnValue true
        spyOn Comments.collection, "update"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue {_id: "user1", isAdmin: -> false}
        
        c = Comments.collection._transform _id: "111", author: "user2"
        expect(c.canUpdate()).toBe(false)
        expect(c.remove).toThrow()
        expect(-> c.update("text")).toThrow()
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Comments.collection.remove).not.toHaveBeenCalled()
        expect(Comments.collection.update).not.toHaveBeenCalled()
        
    it "should not be possible to remove for non-logged-in", ->
        spyOn Comments.collection, "remove"
            .and.returnValue true
        spyOn Comments.collection, "update"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue null
        
        c = Comments.collection._transform _id: "111", author: "user2"
        expect(c.canUpdate()).toBe(false)
        expect(c.remove).toThrow()
        expect(-> c.update("text")).toThrow()
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Comments.collection.remove).not.toHaveBeenCalled()
        expect(Comments.collection.update).not.toHaveBeenCalled()
        
    it "should be possible to remove for author", ->
        spyOn Comments.collection, "remove"
            .and.returnValue true
        spyOn Comments.collection, "update"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue _id: "user2"
        
        c = Comments.collection._transform _id: "111", author: "user2"
        c.update("abc")
        c.remove()
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Comments.collection.update).toHaveBeenCalledWith _id: "111",
            $set:
                text: "abc"
        expect(Comments.collection.remove).toHaveBeenCalledWith "111"
        
    it "should be possible to remove for admin", ->
        spyOn Comments.collection, "remove"
            .and.returnValue true
        spyOn Comments.collection, "update"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue {_id: "user1", isAdmin: -> true}
        
        c = Comments.collection._transform _id: "111", author: "user2"
        c.update("abc")
        c.remove()
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Comments.collection.update).toHaveBeenCalledWith _id: "111",
            $set:
                text: "abc"
        expect(Comments.collection.remove).toHaveBeenCalledWith "111"
        
    it "should return author", ->
        spyOn Users, "findById"
            .and.returnValue "123"
        spyOn Reviews, "findById"
            .and.returnValue "456"
        
        c = Comments.collection._transform author: "user", review: "rev", text: ""
        a = c.getAuthor()
        r = c.getReview()
            
        expect(a).toBe "123"
        expect(r).toBe "456"
        expect(Users.findById).toHaveBeenCalledWith "user"
        expect(Reviews.findById).toHaveBeenCalledWith "rev"
        
