Router.route '/user/:id/comments', name: 'userComments'
class @UserCommentsController extends PagableRouteController
    perPage: 10

    waitOn: ->
        @subscribe 'userComments', @params.id, @limit()
        
    subscriptions: ->
        @subscribe 'universities'
        @subscribe 'categories'
        @subscribe 'users'
        @subscribe 'comments'
        @subscribe 'reviews'
        if Users.currentUser()
            @subscribe 'userNotifications'

    data: ->
        uId = this.params.id
        Users.findById uId

    loaded: ->
        @limit() > Comments.findByUser(@params.id).count

    onRun: ->
        @resetLimit()
        @next()
        
    title: ->
        "Последние комментарии"