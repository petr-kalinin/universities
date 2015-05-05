Meteor.publish 'reviews', (limit = undefined) ->
    Reviews.findAll(limit)

Meteor.publish 'universityReviews', (universityId) ->
    Reviews.findByUniversity(Universities.findById(universityId))

Meteor.publish 'userReviews', (userId, limit = undefined) ->
    Reviews.findByUser(Users.findById(userId), limit)
