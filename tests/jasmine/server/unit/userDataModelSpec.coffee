describe "User", ->
    it "shoud return current user", ->
        spyOn Meteor, "user"
            .and.returnValue "abc"
         
        a = Users.currentUser()
        
        expect(a).toBe("abc")
        expect(Meteor.user).toHaveBeenCalled()
        
    it "should be possible to find by id", ->
        spyOn Users.collection, "findOne"
            .and.returnValue "abc"
        
        a = Users.findById("abc")
        
        expect(a).toBe("abc")
        expect(Users.collection.findOne).toHaveBeenCalledWith _id: "abc"

    it "should properly return public data", ->
        spyOn Users.collection, "find"
            .and.callFake (request, parameters) ->
                fields = 
                    "profile.name": 1
                    "services.vk.id": 1
                    "services.vk.photo": 1
                expect(request).toEqual {}
                expect(parameters).toEqual fields: fields
                "abc"
        
        a = Users.findPublicData()
        
        expect(a).toBe("abc")
        expect(Users.collection.find).toHaveBeenCalled()

    it "should distinguish admin and non-admin", ->
        admin = Users.collection._transform admin: true
        nonAdmin = Users.collection._transform admin: false
        unknown = Users.collection._transform {}
        
        expect(admin.isAdmin()).toBe true
        expect(nonAdmin.isAdmin()).toBe false
        expect(unknown.isAdmin()).toBe false
        
    it "should return profile data", ->
        user = Users.collection._transform
            profile: {name: "his-name"},
            services:
                vk:
                    id: 123456
                    photo: "http://a.b"
                        
        expect(user.name()).toBe "his-name"
        expect(user.externalProfile()).toBe "https://vk.com/id123456"
        expect(user.avatar()).toBe "http://a.b"