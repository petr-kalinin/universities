Router.route '/university', name: 'allUniversities'
class @AllUniversitiesController extends RouteController
    subscriptions: ->
        @subscribe 'universities'
        @subscribe 'comments'
        @subscribe 'users'
        
    data: ->
    