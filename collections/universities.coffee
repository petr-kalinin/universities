universitiesSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true

UniversitiesCollection = new Mongo.Collection 'universities'
UniversitiesCollection.attachSchema universitiesSchema

UniversitiesCollection.allow
    insert: (userId, doc) ->
        Universities.canCreate()
    
    remove: (userId, doc) ->
        doc = UniversitiesCollection._transform doc
        doc.canRemove()
        
UniversitiesCollection.helpers
    canRemove: ->
        if not Users.currentUser()
            return false
        comment = Comments.findOneByUniversity this
        if comment?
            return false
        else
            return true

    remove: ->
        if not this.canRemove()
            throw new Meteor.Error "cant-remove", "The university has comments"
        Universities.collection.remove(this._id)
        
Universities =
    canCreate: ->
        if Users.currentUser()
            return true
        else 
            return false
    
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
