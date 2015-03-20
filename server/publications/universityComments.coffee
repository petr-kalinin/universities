Meteor.publish 'universityComments', (universityId) ->
    CommentsCollection.find 
        "university": universityId
