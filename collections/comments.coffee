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

@CommentsCollection = Comments
