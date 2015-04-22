Router.route '/', name: 'home'
class @HomeController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'universities'
        @subscribe 'reviews'
        @subscribe 'users'
