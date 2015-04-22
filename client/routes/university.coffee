Router.route '/university/:id', name: 'university'
class @UniversityController extends ControllerWithTitle
    waitOn: ->
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
            
    getUniversity: ->
        Universities.findById this.params.id
            
