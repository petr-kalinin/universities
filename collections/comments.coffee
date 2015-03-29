commentsSchema = SimpleSchema.build SimpleSchema.timestamp,
  'university':
    type: String
    index: true
  'text':
    type: String
  'category':
    type: String
  'author':
      type: String

CommentsCollection = new Mongo.Collection 'comments'
CommentsCollection.attachSchema commentsSchema

CommentsCollection.allow
    insert: (userId, doc) ->
        userId && userId == doc.author
    remove: (userId, doc) ->
        userId && userId == doc.author
        
CommentsCollection.helpers
    remove: ->
        user = Users.currentUser()
        if user && user._id == @author
            Comments.collection.remove @_id
        else
            throw new Meteor.Error "permission-denied", "Only author can remove comment"

Comments =
    create: (university, category, text, author) ->
        if not author
            throw new Meteor.Error "permission-denied", "Unauthorized used can not create comments"
        @collection.insert
            university: university._id,
            category: category._id,
            text: text,
            author: author._id
        
    find: (university, category) ->
        @collection.find
            university: university._id,
            category: category._id,
        
    findAll: ->
        @collection.find {}
        
    findOneByUniversity: (university) ->
        @collection.findOne university: university._id
        
    findByUniversity: (university) ->
        @collection.find university: university._id

    collection: CommentsCollection
    
@Comments = Comments
