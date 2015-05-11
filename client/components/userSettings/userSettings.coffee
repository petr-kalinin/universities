Template.userSettings.helpers
    reviewCount: -> 
        Reviews.findByUser(this).count()

    commentCount: -> 
        Comments.findByUser(this).count()
        
    isSelf: ->
        (this._id == Users.currentUser()?._id) and (!this.hideNotifications)
        
    notifications: ->
        Notifications.findByUser(Users.currentUser())
        
    sendConfirmationEmailText: ->
        "Повторно выслать подтерждение"
        
    emailVerified: ->
        true
        
