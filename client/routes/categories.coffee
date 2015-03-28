Router.route '/categories', name: 'category'
class @CategoryController extends RouteController
    subscriptions: ->
        @subscribe 'categories'
        
    data: ->
        Categories.findRoot()
    