Router.route '/university', name: 'allUniversities'
class @AllUniversitiesController extends ControllerWithTitle
    subscriptions: ->
        @subscribe 'universities'
        @subscribe 'reviews'
        @subscribe 'users'
        
    data: ->
    
