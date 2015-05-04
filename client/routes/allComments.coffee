Router.route '/comments', name: 'allComments'
class @AllCommentsController extends PagableRouteController
    perPage: 10

    waitOn: ->
        @subscribe 'comments', @limit()
        @subscribe 'universities'
        @subscribe 'users'
        
    subscriptions: ->
        @subscribe 'reviews'
        @subscribe 'categories'
        if Users.currentUser()
            @subscribe 'userNotifications'

    data: ->
        Comments.findAll()

    loaded: ->
        @limit() > Comments.count()

    onRun: ->
        @resetLimit()
        @next()
        
    title: ->
        "Последние комментарии"