universitiesSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true

# регистрируем коллекцию и добавляем схему
Universities = new Mongo.Collection 'universities'
Universities.attachSchema universitiesSchema

@UniversitiesCollection = Universities
