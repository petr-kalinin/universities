Router.route '/university/:id', name: 'university'
class @UniversityController extends RouteController
    subscriptions: ->
        @subscribe 'universities'
        @subscribe 'categories'
        @subscribe 'universityComments',@ .params.id
        
    data: ->
        uId = this.params.id
        #this.setId = uId
        UniversitiesCollection.findOne _id: uId
    