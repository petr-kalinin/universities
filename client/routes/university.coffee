Router.route '/university/:id', name: 'university'
class @UniversityController extends ControllerWithTitle
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
        
    title: ->
        Universities.findById this.params.id
            .name