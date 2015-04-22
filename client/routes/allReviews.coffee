Router.route '/reviews', name: 'allReviews'
class @AllReviewsController extends PagableRouteController
    perPage: 10

    waitOn: ->
        @subscribe 'reviews', @limit()
        @subscribe 'universities'
        @subscribe 'users'
        @subscribe 'categories'

    data: ->
        Reviews.findAll()

    loaded: ->
        @limit() > Reviews.count()

    onRun: ->
        @resetLimit()
        @next()
        
    title: ->
        "Последние отзывы"