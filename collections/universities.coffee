universitiesSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true

UniversitiesCollection = new Mongo.Collection 'universities'
UniversitiesCollection.attachSchema universitiesSchema

UniversitiesCollection.allow
    insert: (userId, doc) ->
        userId && true
    
    remove: (userId, doc) ->
        doc = UniversitiesCollection._transform doc
        userId && doc.canDelete()
        
UniversitiesCollection.helpers "universities",
    canDelete: ->
        comment = Comments.findOneByUniversity this
        if comment?
            return false
        else
            return true

    remove: ->
        if not this.canDelete()
            throw new Meteor.Error "cant-delete", "The university has comments"
        Universities.collection.remove(this._id)
        
Universities =
    create: (name) ->
        @collection.insert
            name: name
            
    findAll: (sorted = false) ->
        arg = {}
        if (sorted)
            arg = sort: {name: 1}
        @collection.find {}, arg

    findById: (id) ->
        @collection.findOne _id: id
        
    collection: UniversitiesCollection
            
            

@Universities = Universities
