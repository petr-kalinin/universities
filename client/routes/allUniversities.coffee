Router.route '/university', name: 'allUniversities'
class @AllUniversitiesController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'universities'
        
    subscriptions: ->
        @subscribe 'reviews'
        @subscribe 'users'
        if Users.currentUser()
            @subscribe 'userNotifications'
        
    data: ->
    
