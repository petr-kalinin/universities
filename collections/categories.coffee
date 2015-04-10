categoriesSchema = SimpleSchema.build SimpleSchema.timestamp,
    'name':
        type: String
        index: true
    'comment':
        type: String
    'parent':
        type: String
        index: true

CategoriesCollection = new Mongo.Collection 'categories'
CategoriesCollection.attachSchema categoriesSchema

CategoriesCollection.helpers
    findChildren: ->
        Categories.collection.find {parent: @_id}
        
    isLeaf: ->
        child = Categories.collection.findOne {parent: @_id}
        !child
        
    update: (name, comment) ->
        if not Categories.canUpdate()
            throw new Meteor.Error "permission-denied", "Can't not update category"
        Categories.collection.update _id: @_id,
            $set:
                name: name
                comment: comment
                
    _collapsedKeyName: ->
        "categoryCollapsed_" + this._id
                
    collapsed: ->
        Session.equals(@_collapsedKeyName(), true)
        
    invertCollapsed: ->
        if Session.equals(@_collapsedKeyName(), true)
            Session.set(@_collapsedKeyName(), false)
        else 
            Session.set(@_collapsedKeyName(), true)
        
        
        
CategoriesCollection.allow
    insert: (userId, doc) ->
        Categories.canCreate()
        
    update: (userId, doc) ->
        Categories.canUpdate()

Categories =
    canCreate: ->
        Users.currentUser().isAdmin()
    canUpdate: ->
        Users.currentUser().isAdmin()
    
    create: (name, comment, parent) ->
        if not @canCreate()
            throw new Meteor.Error "permission-denied", "Can't not create category"
        @collection.insert
            name: name
            comment: comment
            parent: parent
            
    findTopLevel: ->
        @collection.find
            parent: @findRoot()?._id
        
    findRoot: ->
        @collection.findOne
            parent: ""
    
    findAll: ->
        @collection.find {}
        
    findById: (id)->
        @collection.findOne id
        
    collection: CategoriesCollection

@Categories = Categories
