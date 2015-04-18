Router.route '/categories', name: 'category'
class @CategoryController extends ControllerWithTitle
    subscriptions: ->
        @subscribe 'categories'
        @subscribe 'users'
        
    data: ->
        Categories.findRoot()
    