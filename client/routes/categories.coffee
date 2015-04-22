Router.route '/categories', name: 'category'
class @CategoryController extends ControllerWithTitle
    waitOn: ->
        @subscribe 'categories'
        @subscribe 'users'
        
    data: ->
        Categories.findRoot()
    