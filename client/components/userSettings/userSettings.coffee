UserEmailEdited =
    isEdited: ->
        true

UserEmailVerified =
    isEdited: ->
        false
        
    glyphClass: ->
        "glyphicon-ok text-success"
        
    comment: ->
        "Адрес подтвержден"
        
    needVerificationLink: ->
        false

UserEmailNonVerified =
    isEdited: ->
        false
        
    glyphClass: ->
        "glyphicon-warning-sign text-warning"
        
    comment: ->
        "Письмо для подтверждения адреса выслано."
        
    needVerificationLink: ->
        true

UserEmailAbsent =
    isEdited: ->
        false
        
    glyphClass: ->
        "glyphicon-remove text-danger"
        
    comment: ->
        "Вы не указали email, письма с оповещением не будут приходить."
        
    needVerificationLink: ->
        false

UserEmail = UserEmailNonVerified

Template.userSettings.helpers
    reviewCount: -> 
        Reviews.findByUser(this).count()

    commentCount: -> 
        Comments.findByUser(this).count()
        
    isSelf: ->
        (this._id == Users.currentUser()?._id) and (!this.hideNotifications)
        
    notifications: ->
        Notifications.findByUser(Users.currentUser())
        
    inputGroupIfEdited: ->
        if UserEmail.isEdited()
            "input-group"
        else
            ""
            
    isEdited: ->
        UserEmail.isEdited()
        
    glyphClass: ->
        UserEmail.glyphClass()
        
    comment: ->
        UserEmail.comment()

    needVerificationLink: ->
        UserEmail.needVerificationLink()