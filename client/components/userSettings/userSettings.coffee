Template.userSettings.events
    "input #email": (e) ->
        Session.set("currentEmailEdited", e.target.value)

    "submit .set-email": (e) ->
        Session.set("currentEmailEdited", undefined)
        Users.currentUser().setEmail(e.target.email.value)
        e.preventDefault()
        false

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

UserEmail = ->
    if (Users.currentUser()?.email())
        email = Users.currentUser().email()
    else
        email = {address: "", verified: undefined}
    currentEmailEdited = Session.get("currentEmailEdited")
    if currentEmailEdited and (currentEmailEdited != email.address)
        UserEmailEdited
    else
        if email.address == ""
            UserEmailAbsent
        else
            if email.verified
                UserEmailVerified
            else UserEmailNonVerified

Template.userSettings.helpers
    reviewCount: -> 
        Reviews.findByUser(this).count()

    commentCount: -> 
        Comments.findByUser(this).count()
        
    isSelf: ->
        (this._id == Users.currentUser()?._id) and (!this.hideNotifications)
        
    notifications: ->
        Notifications.findByUser(Users.currentUser())
        
    emailAddress: ->
        email = @email()
        if email
            email.address
        else
            ""
        
    inputGroupIfEdited: ->
        if UserEmail().isEdited()
            "input-group"
        else
            ""
            
    isEdited: ->
        UserEmail().isEdited()
        
    glyphClass: ->
        UserEmail().glyphClass()
        
    comment: ->
        UserEmail().comment()

    needVerificationLink: ->
        UserEmail().needVerificationLink()