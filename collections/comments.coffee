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
    insert: (userId, doc) ->
        trDoc = CommentsCollection._transform doc
        trDoc.canCreate()
    remove: (userId, doc) ->
        trDoc = CommentsCollection._transform doc
        trDoc.canUpdate()
    update: (userId, doc) ->
        trDoc = CommentsCollection._transform doc
        trDoc.canUpdate()
        
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
        if @canUpdate()
            Comments.collection.remove @_id
        else
            throw new Meteor.Error "permission-denied", "Only author can remove comment"

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
        baseDoc = 
            review: review?._id,
            text: text,
            author: author?._id
        doc = @collection._transform baseDoc
        if not doc.canCreate()
            throw new Meteor.Error "permission-denied", "Can't not create comments"
        @collection.insert baseDoc
        
    find: (review) ->
        @collection.find {
            review: review._id
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
