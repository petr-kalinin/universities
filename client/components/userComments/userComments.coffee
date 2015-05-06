Template.userComments.helpers
    userNoNotify: ->
        user = this
        user.hideNotifications = true
        user
        
    comments: ->
        Comments.findByUser this
        
