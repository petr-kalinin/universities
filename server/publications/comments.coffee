Meteor.publish 'reviewComments', (id) ->
    Comments.find(Reviews.findById(id))

