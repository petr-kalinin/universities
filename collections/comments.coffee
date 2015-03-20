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

# регистрируем коллекцию и добавляем схему
Comments = new Mongo.Collection 'comments'
Comments.attachSchema commentsSchema

Comments.allow
    insert: (userId, doc) ->
        userId && true

@CommentsCollection = Comments
