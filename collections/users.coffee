UsersCollection = Meteor.users

#for testing: for some reason, in Jasmine Meteor.users.helpers is not set
if !Meteor.users.helpers
    Meteor.users.helpers = Mongo.Collection.prototype.helpers

Meteor.users.helpers "Users",
    isAdmin: ->
        if @admin
            @admin
        else 
            false
        
    name: ->
        @profile.name
    
    vkHref: ->
        "https://vk.com/id" + @services.vk.id
    
    vkPhoto: ->
        @services.vk.photo
        
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
        @collection.find {}, fields: fields

    collection: UsersCollection

@Users = Users