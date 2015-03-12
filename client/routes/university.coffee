Router.route '/university/:id', name: 'university'
class @UniversityController extends RouteController
    data: ->
        uId = this.params.id
        #this.setId = uId
        UniversitiesCollection.findOne _id: uId
    