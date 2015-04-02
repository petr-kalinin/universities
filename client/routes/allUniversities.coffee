Router.route '/university', name: 'allUniversities'
class @AllUniversitiesController extends RouteController
    subscriptions: ->
        @subscribe 'universities'
        
    data: ->
    