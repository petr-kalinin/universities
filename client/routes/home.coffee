Router.route '/', name: 'home'
class @HomeController extends ControllerWithTitle
    subscriptions: ->
        @subscribe 'universities'
        @subscribe 'reviews'
        @subscribe 'users'
