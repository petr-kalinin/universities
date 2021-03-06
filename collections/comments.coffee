commentsSchema = SimpleSchema.build SimpleSchema.timestamp,
  'review':
    type: String
    index: true
  'text':
    type: String
  'author':
      type: String

CommentsCollection = new Mongo.Collection 'comments'
CommentsCollection.attachSchema commentsSchema

CommentsCollection.allow
    # no insert and remove allowed
    # because this is done only via meteor method
    # to ensure notification is created
    update: (userId, doc, fields, modifier) ->
        if not (_.isEqual(fields, ["text", "updatedAt"]))
            return false
        trDoc = CommentsCollection._transform doc
        trDoc.canUpdate()
        
Meteor.methods
    createComment: (review, text, author) ->
        baseDoc = 
            review: review?._id,
            text: text,
            author: author?._id
        doc = Comments.collection._transform baseDoc
        if not doc.canCreate()
            throw new Meteor.Error "permission-denied", "Can't not create comments"
        doc._id = Comments.collection.insert baseDoc
        Notifications.createFromComment doc

    removeComment: (id) ->
        comment = Comments.findById id
        if !comment.canUpdate()
            throw new Meteor.Error "permission-denied", "Only author can remove comment"
        Comments.collection.remove comment._id
        Notifications.removeByEventId comment._id
        
CommentsCollection.helpers
    canUpdate: ->
        user = Users.currentUser()
        if user && (user._id == @author || user.isAdmin())
            return true
        else
            return false
        
    canCreate: ->
        user = Users.currentUser()
        if Comments.userCanCreate() && @text && @review && user._id == @author
            return true
        else
            return false

    remove: ->
        Meteor.call "removeComment", @_id

    update: (text) ->
        if not @canUpdate()
            throw new Meteor.Error "permission-denied", "Only author can update comment"
        Comments.collection.update _id: @_id,
            $set:
                text: text
    
    getAuthor: ->
        Users.findById(this.author)
        
    getReview: ->
        Reviews.findById(this.review)
        
    createdDate: ->
        @createdAt
            
CommentsCollection.helpers BooleanProperty

CommentsCollection.helpers
    _booleanPropertyName: (name) ->
        "comments_" + name + "_" + this._id

    isEdited: ->
        @_booleanProperty("isEdited", false)
        
    toggleIsEdited: ->
        @_toggleBooleanProperty("isEdited", false)
            


Comments =
    userCanCreate: ->
        user = Users.currentUser()
        if (user)
            return true
        else 
            return false

    create: (review, text, author) ->
        Meteor.call "createComment", review, text, author
                
    find: (review) ->
        @collection.find {
            review: review._id
        }, sort: {createdAt: 1}
        
    findById: (id)->
        @collection.findOne id

    findByUser: (user) ->
        @collection.find {
            author: user._id
        }, sort: {createdAt: 1}
        
    findAll: (limit = undefined, sort = undefined) ->
        if not sort
            sort = -1
        sort = createdAt: sort
        @collection.find {}, if limit then limit: limit, sort: sort else sort: sort
        
    count: ->
        @findAll().count()

    collection: CommentsCollection
    
@Comments = Comments

