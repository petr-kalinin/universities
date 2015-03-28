Meteor.publish 'categories', ->
    Categories.findAll()