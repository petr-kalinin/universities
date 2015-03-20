Meteor.publish 'categories', ->
    CategoriesCollection.find {}