Meteor.publish 'reviewComments', (id) ->
    Comments.find(id)

