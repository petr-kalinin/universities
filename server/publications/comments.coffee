Meteor.publish 'comments', ->
    CommentsCollection.find {}

