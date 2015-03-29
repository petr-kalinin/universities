Meteor.publish 'users', ->
    fields = 
        "profile.name": 1
        "services.vk.id": 1
        "services.vk.photo": 1
    Users.find {}, fields: fields

