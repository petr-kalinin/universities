Router.route '/review/:id', name: 'reviewComments'
class @ReviewCommentsController extends ControllerWithTitle
    subscriptions: ->
        @subscribe 'universities'
        @subscribe 'categories'
        @subscribe 'reviews'
        @subscribe 'reviewComments', @params.id
        @subscribe 'users'
        
    data: ->
        uId = this.params.id
        Reviews.findById uId
    
    name: ->
        'reviewComments'
        
    title: ->
        "Отзыв"