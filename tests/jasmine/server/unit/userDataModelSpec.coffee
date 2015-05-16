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
                    "admin": 1
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
        expect(user.externalProfileName()).toBe "Профиль вКонтакте"
        
    it "should return email data", ->
        hasEmail = Users.collection._transform
            emails: ["abc"]
        noEmail = Users.collection._transform {}
        noEmail2 = Users.collection._transform 
            emails: []
        
        expect(hasEmail.email()).toBe "abc"
        expect(noEmail.email()).toBeUndefined()
        expect(noEmail2.email()).toBeUndefined()
        
    it "should set email", ->
        spyOn Users.collection, "update"
            .and.returnValue true
        spyOn Meteor, "userId"
            .and.returnValue "user"
        
        curUser = 
            sendVerificationEmail: ->
                true
        spyOn curUser, "sendVerificationEmail"
            .and.returnValue true
        spyOn Meteor, "user"
            .and.returnValue curUser
        
        oldEmail = Users.collection._transform
            _id: "user"
            emails: [address: "a@b"]
        noEmail = Users.collection._transform 
            _id: "user"
        wrongUser = Users.collection._transform 
            _id: "wrong"
                
        expect(-> wrongUser.setEmail("a@b")).toThrow()
        expect(Users.collection.update).not.toHaveBeenCalled()
        expect(curUser.sendVerificationEmail).not.toHaveBeenCalled()
        
        oldEmail.setEmail("a@b")
        expect(Users.collection.update).not.toHaveBeenCalled()
        expect(curUser.sendVerificationEmail).not.toHaveBeenCalled()
        
        oldEmail.setEmail("a@c")
        expect(Users.collection.update).toHaveBeenCalledWith "user",
            {$set:
                emails: [{address: "a@c", verified: false}]}
        expect(curUser.sendVerificationEmail).toHaveBeenCalled()
        
        noEmail.setEmail("a@d")
        expect(Users.collection.update).toHaveBeenCalledWith "user",
            {$set:
                emails: [{address: "a@d", verified: false}]}
        expect(curUser.sendVerificationEmail).toHaveBeenCalled()
        
    it "should return empty profile for non-user", ->
        user = Users.collection._transform null
                        
        expect(user.name()).toBe undefined
        expect(user.externalProfile()).toBe undefined
        expect(user.avatar()).toBe undefined
        
    it "should send verification email", ->
        spyOn Meteor, "userId"
            .and.returnValue "user"
        spyOn Accounts, "sendVerificationEmail"
            .and.returnValue "true"
        
        thisUser = Users.collection._transform 
            _id: "user"
        wrongUser = Users.collection._transform 
            _id: "wrong"
                
        wrongUser.sendVerificationEmail()
        expect(Accounts.sendVerificationEmail).not.toHaveBeenCalled()
        
        thisUser.sendVerificationEmail()
        expect(Accounts.sendVerificationEmail).toHaveBeenCalledWith "user"
        
    it "should send email", ->
        spyOn Email, "send"
            .and.returnValue true
        
        noEmail = Users.collection._transform {}
        noEmail2 = Users.collection._transform 
            emails: []
        notVerified = Users.collection._transform 
            emails: [{address: "a@b", verified: false}]
        good = Users.collection._transform 
            emails: [{address: "a@c", verified: true}]
            
        expect(->noEmail.sendEmail("a", "b")).toThrow()
        expect(->noEmail2.sendEmail("a", "b")).toThrow()
        expect(->notVerified.sendEmail("a", "b")).toThrow()
        expect(Email.send).not.toHaveBeenCalled()
            
        good.sendEmail("c", "d")
        expect(Email.send).toHaveBeenCalledWith
            from: "Обзор университетов <universities@kalinin.nnov.ru>",
            to: "a@c",
            subject: "c",
            text: "d"
        