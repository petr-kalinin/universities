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

Comments = new Mongo.Collection 'comments'
Comments.attachSchema commentsSchema

Comments.allow
    insert: (userId, doc) ->
        userId && userId == doc.author
    remove: (userId, doc) ->
        userId && userId == doc.author
        
@CommentsCollection = Comments
