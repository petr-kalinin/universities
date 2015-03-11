Router.route '/university/:id', name: 'university'
class @UniversityController extends RouteController
    data: ->
        uId = this.params.id
        UniversitiesCollection.findOne _id: uId
    