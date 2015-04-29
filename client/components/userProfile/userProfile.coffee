Template.userProfile.helpers
    reviewCount: -> 
        Reviews.findByUser(this).count()

    commentCount: -> 
        Comments.findByUser(this).count()
        
    isSelf: ->
        this._id == Users.currentUser()?._id
        
    notifications: ->
        Notifications.findByUser(Users.currentUser())
