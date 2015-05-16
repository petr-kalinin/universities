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
                event: "event1",
                read: false,
                notified: []

    it "should be able to find by its id", ->
        spyOn Notifications.collection, "findOne"
            .and.returnValue "foo"
        
        result = Notifications.findById("bar")
        
        expect(result).toBe("foo")
        expect(Notifications.collection.findOne).toHaveBeenCalledWith "bar"
                    
    it "should be able to find by user", ->
        spyOn Notifications.collection, "find"
            .and.returnValue "abc"
        
        x = Notifications.findByUser(_id: "user1")
        
        expect(x).toEqual "abc"
        expect(Notifications.collection.find)
            .toHaveBeenCalledWith {
                user: "user1"
            }, sort: {createdAt: -1}
 
    it "should be able to get comment and link", ->
        spyOn Meteor, "absoluteUrl"
            .and.returnValue "http://a.b/"
        spyOn Comments, "findById"
            .and.returnValue review: "123"

        iscomment = Notifications.collection._transform 
            type: "comment"
            event: "qwe"
        noncomment = Notifications.collection._transform 
            type: "noncomment"
            event: "abc"
        
        expect(iscomment.isComment()).toBe(true)
        expect(noncomment.isComment()).toBe(false)
        expect(iscomment.comment()).toEqual(review: "123")
        expect(noncomment.comment).toThrow()
        
        expect(iscomment.link()).toBe("http://a.b/review/123")
        
        expect(Comments.findById).toHaveBeenCalledWith "qwe"
 
    it "should be able to find unread", ->
        spyOn Users, "currentUser"
            .and.returnValue _id: "123"
        spyOn Notifications.collection, "find"
            .and.returnValue "res"
        
        x = Notifications.findMyUnread()
        
        expect(x).toBe("res")
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Notifications.collection.find).toHaveBeenCalledWith {
                user: "123",
                read: false
            }, sort: {createdAt: -1}
    
    it "should be anle to find non notified", ->
        spyOn Notifications.collection, "find"
            .and.returnValue "foo"
        
        x = Notifications.findNonNotified("email")
        
        expect(x).toBe("foo")
        expect(Notifications.collection.find).toHaveBeenCalledWith {
            read: false,
            notified: {"$ne": "email"}
        }, sort: {createdAt: 1}
        
    it "should be possible to update for author", ->
        spyOn Notifications.collection, "update"
            .and.returnValue true
        spyOn Users, "currentUser"
            .and.returnValue _id: "user2"
        
        c = Notifications.collection._transform _id: "111", user: "user2"
        expect(c.canUpdate()).toBe(true)
        c.markAsRead()
        c2 = Notifications.collection._transform _id: "333", user: "user22"
        expect(c2.canUpdate()).toBe(false)
        expect(-> c2.marAsread()).toThrow()
            
        expect(Users.currentUser).toHaveBeenCalled()
        expect(Notifications.collection.update).toHaveBeenCalledWith _id: "111",
            $set:
                read: true
                    
    it "should be possible to mark as notified", ->
        spyOn Notifications.collection, "update"
            .and.returnValue true
        
        c = Notifications.collection._transform _id: "111"
        c.markAsNotified("email")
        
        expect(Notifications.collection.update).toHaveBeenCalledWith _id: "111",
            $push:
                notified: "email"
                    
    it "should be able to remove by event", ->
        spyOn Notifications.collection, "remove"
            .and.returnValue true
        
        Notifications.removeByEventId("123")
        
        expect(Notifications.collection.remove).toHaveBeenCalledWith event: "123"
        
            