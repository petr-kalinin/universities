Meteor.publish 'userNotifications', ->
    if this.userId
        Notifications.findByUser(Users.findById(this.userId))
    else
        undefined
