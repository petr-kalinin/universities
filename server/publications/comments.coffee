Meteor.publish 'comments', ->
    Comments.findAll()

