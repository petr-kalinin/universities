Router.route '/user/:id/reviews', name: 'userReviews'
class @UserReviewsController extends PagableRouteController
    perPage: 10

    waitOn: ->
        @subscribe 'userReviews', @params.id, @limit()
        @subscribe 'universities'
        @subscribe 'categories'
        
    subscriptions: ->
        @subscribe 'users'
        @subscribe 'comments'
        @subscribe 'reviews'
        if Users.currentUser()
            @subscribe 'userNotifications'

    data: ->
        uId = this.params.id
        Users.findById uId

    loaded: ->
        @limit() > Reviews.findByUser(@params.id).count

    onRun: ->
        @resetLimit()
        @next()
        
    title: ->
        "Последние отзывы"