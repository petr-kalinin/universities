Router.route '/categories', name: 'category'
class @CategoryController extends RouteController
    subscriptions: ->
        @subscribe 'categories'
        @subscribe 'users'
        
    data: ->
        Categories.findRoot()
    