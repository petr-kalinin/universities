Router.route '/university/:id', name: 'university'
class @UniversityController extends RouteController
    subscriptions: ->
        @subscribe 'universities'
        @subscribe 'categories'
        @subscribe 'universityReviews', @params.id
        @subscribe 'users'
        
    data: ->
        uId = this.params.id
        Universities.findById uId
    
    name: ->
        'university'