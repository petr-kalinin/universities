universitiesSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true

# регистрируем коллекцию и добавляем схему
Universities = new Mongo.Collection 'universities'
Universities.attachSchema universitiesSchema

Universities.allow
    insert: (userId, doc) ->
        userId && true

@UniversitiesCollection = Universities
