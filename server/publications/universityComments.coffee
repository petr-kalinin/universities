Meteor.publish 'universityComments', (universityId) ->
    Comments.findByUniversity(Universities.findById(universityId))
