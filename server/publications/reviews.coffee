Meteor.publish 'reviews', ->
    Reviews.findAll()

