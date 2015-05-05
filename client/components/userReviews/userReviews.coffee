Template.userReviews.helpers
    userNoNotify: ->
        user = this
        user.hideNotifications = true
        user
        
    reviews: ->
        Reviews.findByUser this
        
