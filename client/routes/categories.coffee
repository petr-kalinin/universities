Router.route '/categories', name: 'category'
class @CategoryController extends RouteController
    data: ->
        CategoriesCollection.findOne parent: ''
    