describe "Notification", ->
    it "should be created with user and comment", ->
        spyOn Reviews, "findById"
            .and.returnValue author: "user1"
        spyOn Notifications.collection, "insert"
            .and.returnValue true
        
        Notifications.createFromComment {_id:"event1", review: "rev1"}
        
        expect(Reviews.findById)
            .toHaveBeenCalledWith "rev1"
        expect(Notifications.collection.insert)
            .toHaveBeenCalledWith 
                user: "user1", 
                type: "comment", 
                event: "event1"
                    
    it "should be able to find by user", ->
        spyOn Notifications.collection, "find"
            .and.returnValue "abc"
        
        x = Notifications.findByUser(_id: "user1")
        
        expect(x).toEqual "abc"
        expect(Notifications.collection.find)
            .toHaveBeenCalledWith {
                user: "user1"
            }, sort: {createdAt: 1}
 
