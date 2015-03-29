Meteor.publish 'users', ->
    Users.findPublicData()
