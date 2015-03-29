describe "Comment", ->
    it "should be created with univ, cat, text, author", ->
        spyOn Comments.collection, "insert"
            .and.returnValue true

        Comments.create {_id: "univ"}, {_id: "cat"}, "text", {_id: "user"}
 
        expect(Comments.collection.insert).toHaveBeenCalledWith
            university: "univ",
            category: "cat",
            text: "text",
            author: "user"
                
    it "should not be created without author", ->
        spyOn Comments.collection, "insert"
            .and.returnValue true

        try
            Comments.create {_id: "univ"}, {_id: "cat"}, "text", null
        catch error
            expect(error.error).toBe("permission-denied")
            
        expect(Comments.collection.insert).not.toHaveBeenCalled
                
    it "should be possible to find by university and category", ->
        spyOn Comments.collection, "find"
            .and.returnValue "111"

        a = Comments.find {_id: "univ"}, {_id: "cat"}

        expect(a).toBe("111")
        expect(Comments.collection.find).toHaveBeenCalledWith
            university: "univ",
            category: "cat"
                
    it "should be possible to find all", ->
        spyOn Comments.collection, "find"
            .and.returnValue "111"

        a = Comments.findAll()
 
        expect(a).toBe("111")
        expect(Comments.collection.find).toHaveBeenCalledWith {}
                
    it "should be possible to find by university", ->
        spyOn Comments.collection, "find"
            .and.returnValue "111"
        spyOn Comments.collection, "findOne"
            .and.returnValue "222"

        a = Comments.findByUniversity {_id: "univ1"}
        b = Comments.findOneByUniversity {_id: "univ2"}
 
        expect(a).toBe("111")
        expect(b).toBe("222")
        expect(Comments.collection.find).toHaveBeenCalledWith university: "univ1"
        expect(Comments.collection.findOne).toHaveBeenCalledWith university: "univ2"
                
    it "should not be possible to remove for non-author", ->
        spyOn Comments.collection, "remove"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue _id: "user1"
        
        c = Comments.collection._transform _id: "111", author: "user2"
        try
            c.remove()
        catch error
            expect(error.error).toBe("permission-denied")
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Comments.collection.remove).not.toHaveBeenCalled()
        
    it "should not be possible to remove for non-logged-in", ->
        spyOn Comments.collection, "remove"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue null
        
        c = Comments.collection._transform _id: "111", author: "user2"
        try
            c.remove()
        catch error
            expect(error.error).toBe("permission-denied")
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Comments.collection.remove).not.toHaveBeenCalled()
        
    it "should be possible to remove for author", ->
        spyOn Comments.collection, "remove"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue _id: "user2"
        
        c = Comments.collection._transform _id: "111", author: "user2"
        c.remove()
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Comments.collection.remove).toHaveBeenCalledWith "111"
        
