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
        trDoc.canRemove()
        
ReviewsCollection.helpers
    canRemove: ->
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
        if @canRemove()
            Reviews.collection.remove @_id
        else
            throw new Meteor.Error "permission-denied", "Only author can remove review"
    
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
        
    count: ->
        @findAll().count()

    collection: ReviewsCollection
    
@Reviews = Reviews
