Meteor.publish 'reviews', (limit = undefined) ->
    Reviews.findAll(limit)

Meteor.publish 'universityReviews', (universityId) ->
    Reviews.findByUniversity(Universities.findById(universityId))
