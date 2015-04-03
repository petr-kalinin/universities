Router.route '/', name: 'home'
class @HomeController extends RouteController
    subscriptions: ->
        @subscribe 'universities'
        @subscribe 'reviews'
        @subscribe 'users'
