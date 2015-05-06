Meteor.publish 'reviewComments', (id) ->
    Comments.find(Reviews.findById(id))

Meteor.publish 'comments', ->
    Comments.findAll()

Meteor.publish 'userComments', (userId, limit = undefined) ->
    Comments.findByUser(Users.findById(userId), limit)
