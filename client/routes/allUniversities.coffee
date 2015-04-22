Router.route '/university', name: 'allUniversities'
class @AllUniversitiesController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'universities'
        @subscribe 'reviews'
        @subscribe 'users'
        
    data: ->
    
