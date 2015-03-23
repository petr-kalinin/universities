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
            
if Meteor.isServer
    Meteor.methods
        UniversityRemove: (id) ->
            comment = CommentsCollection.findOne university: id
            if comment?
                throw new Meteor.Error "cant-delete", "The university has comments"
            Universities.remove
                id: id
            
Universities.helpers
    remove: (callback) ->
        Meteor.call("UniversityRemove", this._id, callback)
            

@UniversitiesCollection = Universities
