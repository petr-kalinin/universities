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
            
Universities.helpers
    canDelete: ->
        comment = CommentsCollection.findOne university: this._id
        if comment?
            return false
        else
            return true

    remove: (callback) ->
        if not this.canDelete()
            throw new Meteor.Error "cant-delete", "The university has comments"
        Universities.remove
            id: this._id
            

@UniversitiesCollection = Universities
