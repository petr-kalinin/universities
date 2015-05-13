Meteor.publish 'users', ->
    Users.findPublicData()

Meteor.publish 'userProfile', ->
    if Users.currentUser()
        Users.currentUser().getProfile()
    else
        @ready()