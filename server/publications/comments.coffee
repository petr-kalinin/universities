Meteor.publish 'reviewComments', (id) ->
    Comments.find(Reviews.findById(id))

Meteor.publish 'comments', ->
    Comments.findAll()
