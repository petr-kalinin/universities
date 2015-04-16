defaultCreatedDate = new Date(2015, 3, 5, 0, 0, 0, 0);

reviewsSchema = SimpleSchema.build SimpleSchema.timestamp,
  'university':
    type: String
    index: true
  'text':
    type: String
  'category':
    type: String
  'author':
      type: String

ReviewsCollection = new Mongo.Collection 'reviews'
ReviewsCollection.attachSchema reviewsSchema

ReviewsCollection.allow
    insert: (userId, doc) ->
        trDoc = ReviewsCollection._transform doc
        trDoc.canCreate()
    remove: (userId, doc) ->
        trDoc = ReviewsCollection._transform doc
        trDoc.canUpdate()
    update: (userId, doc) ->
        trDoc = ReviewsCollection._transform doc
        trDoc.canUpdate()
        
ReviewsCollection.helpers
    canUpdate: ->
        user = Users.currentUser()
        if user && (user._id == @author || user.isAdmin())
            return true
        else
            return false
        
    canCreate: ->
        user = Users.currentUser()
        if Reviews.userCanCreate() && @university && @category && @text && @author && user._id == @author
            return true
        else
            return false

    remove: ->
        if @canUpdate()
            Reviews.collection.remove @_id
        else
            throw new Meteor.Error "permission-denied", "Only author can remove review"

    update: (text) ->
        if not @canUpdate()
            throw new Meteor.Error "permission-denied", "Only author can remove review"
        Reviews.collection.update _id: @_id,
            $set:
                text: text
    
    getAuthor: ->
        Users.findById(this.author)

    getUniversity: ->
        Universities.findById(this.university)
        
    getCategory: ->
        Categories.findById(this.category)
        
    createdDate: ->
        if @createdAt
            @createdAt
        else
            defaultCreatedDate
            
ReviewsCollection.helpers BooleanProperty

ReviewsCollection.helpers
    _booleanPropertyName: (name) ->
        "reviews_" + name + "_" + this._id

    isEdited: ->
        @_booleanProperty("isEdited", false)
        
    toggleIsEdited: ->
        @_toggleBooleanProperty("isEdited", false)
            


Reviews =
    userCanCreate: ->
        user = Users.currentUser()
        if (user)
            return true
        else 
            return false

    create: (university, category, text, author) ->
        baseDoc = 
            university: university?._id,
            category: category?._id,
            text: text,
            author: author?._id
        doc = @collection._transform baseDoc
        if not doc.canCreate()
            throw new Meteor.Error "permission-denied", "Can't not create reviews"
        @collection.insert baseDoc
        
    find: (university, category, findDesc) ->
        if findDesc
            cat = { $in: category.findDescendats() }
        else
            cat = category._id
        @collection.find {
            university: university._id,
            category: cat
        }, sort: {createdAt: 1}
        
    findAll: (limit = undefined, sort = undefined) ->
        if not sort
            sort = -1
        sort = createdAt: sort
        @collection.find {}, if limit then limit: limit, sort: sort else sort: sort
        
    findOneByUniversity: (university) ->
        @collection.findOne university: university._id
        
    findByUniversity: (university) ->
        @collection.find {university: university._id}, sort: {createdAt: 1}

    findById: (id) ->
        @collection.findOne _id: id
        
    count: ->
        @findAll().count()

    collection: ReviewsCollection
    
@Reviews = Reviews
