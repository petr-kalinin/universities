Router.route '/user/:id', name: 'userProfile'
class @UserProfileController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'users'
        
    subscriptions: ->
        @subscribe 'reviews'
        @subscribe 'comments'
        if Users.currentUser()
            @subscribe 'userNotifications'
        
    data: ->
        uId = this.params.id
        Users.findById uId
    
    name: ->
        'user'
        
    title: ->
        Users.findById this.params.id
            ?.name()
