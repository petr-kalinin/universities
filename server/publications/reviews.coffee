Meteor.publish 'reviews', (limit = undefined) ->
    Reviews.findAll(limit)

