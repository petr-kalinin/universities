Meteor.publish 'universityReviews', (universityId) ->
    Reviews.findByUniversity(Universities.findById(universityId))
