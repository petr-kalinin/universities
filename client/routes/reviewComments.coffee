Router.route '/review/:id', name: 'reviewComments'
class @ReviewCommentsController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'universities'
        @subscribe 'categories'
        @subscribe 'reviews'
        @subscribe 'reviewComments', @params.id
        @subscribe 'users'
        
    subscriptions: ->
        if Users.currentUser()
            @subscribe 'userNotifications'
        
    data: ->
        uId = this.params.id
        Reviews.findById uId
    
    name: ->
        'reviewComments'
        
    title: ->
        univ = @getUniversity()?.name
        if univ
            @getUniversity().name + " — отзыв"
        else 
            ""
        
    getUniversity: ->
        Reviews.findById this.params.id
            ?.getUniversity()
    