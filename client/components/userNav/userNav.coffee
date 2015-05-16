Template.userNav.helpers
    currentUser: ->
        user = Users.currentUser()
        if user
            user.badge = Notifications.findMyUnread().count()
            user.checkEmail = true
        user