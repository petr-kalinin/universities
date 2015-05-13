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
                $set:
                    emails: [{address: email, verified: false}]
        else
            Users.collection.update Meteor.userId(),
                $unset:
                    emails: ""

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
        curEmail = @email()
        if (!curEmail) or (newEmail != curEmail.address)
            Meteor.call "setUserEmail", newEmail
            
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