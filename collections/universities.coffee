universitiesSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true

Universities = new Mongo.Collection 'universities'
Universities.attachSchema universitiesSchema

Universities.allow
    insert: (userId, doc) ->
        userId && true
        
_.extend Universities,
    create: (name) ->
        Universities.insert
            name: name

@UniversitiesCollection = Universities
