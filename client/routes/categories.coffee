Router.route '/categories', name: 'category'
class @CategoryController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'categories'
        
    subscriptions: ->
        @subscribe 'users'
        if Users.currentUser()
            @subscribe 'userNotifications'
        
    data: ->
        Categories.findRoot()
    