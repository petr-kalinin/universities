universitiesSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true

Universities = new Mongo.Collection 'universities'
Universities.attachSchema universitiesSchema

Universities.allow
    insert: (userId, doc) ->
        userId && true
    
    remove: (userId, doc) ->
        doc = Universities._transform doc
        userId && doc.canDelete()
        
_.extend Universities,
    create: (name) ->
        Universities.insert
            name: name
            
    findAll: ->
        Universities.find {}, sort: {name: 1}

    findById: (id) ->
        Universities.findOne _id: id
            
Universities.helpers
    canDelete: ->
        comment = CommentsCollection.findOne university: this._id
        if comment?
            return false
        else
            return true

    remove: ->
        if not this.canDelete()
            throw new Meteor.Error "cant-delete", "The university has comments"
        Universities.remove(this._id)
            

@UniversitiesCollection = Universities
