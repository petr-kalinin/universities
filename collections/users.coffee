UsersCollection = Meteor.users

#for testing: for some reason, in Jasmine Meteor.users.helpers is not set
if !Meteor.users.helpers
    Meteor.users.helpers = Mongo.Collection.prototype.helpers

Meteor.methods
    setUserEmail: (email) ->
        if not Meteor.userId()
            return
        if email
            Users.collection.update Meteor.userId(),
                {$set:
                    emails: [{address: email, verified: false}]}
            Meteor.call "sendVerificationEmail", -> 
                true
        else
            Users.collection.update Meteor.userId(),
                $unset:
                    emails: ""
                        
Meteor.methods
    sendVerificationEmail: ->
        Meteor.user().sendVerificationEmail()


Meteor.users.helpers
    isAdmin: ->
        if @admin
            @admin
        else 
            false
        
    name: ->
        @profile?.name
    
    externalProfile: ->
        if @services?.vk?.id
            "https://vk.com/id" + @services.vk.id
        else
            undefined

    externalProfileName: ->
        if @services?.vk?.id
            "Профиль вКонтакте"
        else
            undefined
    
    avatar: ->
        @services?.vk?.photo
        
    email: ->
        if (@emails) and (@emails.length>0)
            @emails[0]
        else
            undefined
            
    setEmail: (newEmail) ->
        if (Meteor.userId() != @_id)
            throw new Meteor.Error "permission-denied", "Can set email only for self"
        curEmail = @email()
        if (!curEmail) or (newEmail != curEmail.address)
            Meteor.call "setUserEmail", newEmail, -> 
                true
    
    sendVerificationEmail: ->
        if Meteor.isClient
            Meteor.call "sendVerificationEmail", ->
                true
            return
        console.log "Sending verification email to ", @_id
        if (@_id != Meteor.userId())
            return
        Accounts.sendVerificationEmail(@_id)
        console.log "sent"
        
    sendEmail: (subject, text) ->
        if Meteor.isClient
            return
        email = @email()
        if not (email?.verified)
            throw new Meteor.Error "email-not-verified", "User email has not been verified"
        @markNotificationTime "email"
        Email.send
            from: "Обзор университетов <universities@kalinin.nnov.ru>",
            to: email.address,
            subject: subject,
            text: text
        
    sendVkNotification: (text) ->
        deltaT = new Date() - @getNotificationTime("vk")
        console.log deltaT
        if deltaT < 1000*60*60*24/2.9
            throw new Meteor.Error "vk-notification-too-frequent", "Vk notification has been sent to frequent"
        console.log "sending to vk"
        @markNotificationTime "vk"
        vkNotifier.request 'secure.sendNotification', {user_id: @services.vk.id, message: text}
        
    getNotificationTime: (method) ->
        time = this?.notificationTimes?[method]
        if not time?
            time = new Date(0)
        console.log "getNotificationTime returning", time
        return time
    
    markNotificationTime: (method) ->
        if Meteor.isClient
            return
        modifier = $set: {}
        modifier.$set["notificationTimes." + method] = new Date()
        Users.collection.update @_id, modifier

            
Users = 
    currentUser: ->
        Meteor.user()
        
    findById: (id) ->
        @collection.findOne _id: id
        
    findPublicData: ->
        fields = 
            "profile.name": 1
            "services.vk.id": 1
            "services.vk.photo": 1
            "admin": 1
        @collection.find {}, fields: fields

    collection: UsersCollection

@Users = Users