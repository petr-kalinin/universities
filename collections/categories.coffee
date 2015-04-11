categoriesSchema = SimpleSchema.build SimpleSchema.timestamp,
    'name':
        type: String
        index: true
    'comment':
        type: String
        optional: true
    'parent':
        type: String
        index: true
    'order':
        type: Number
    'collapsedByDefault':
        type: Boolean

CategoriesCollection = new Mongo.Collection 'categories'
CategoriesCollection.attachSchema categoriesSchema

CategoriesCollection.helpers
    findChildren: ->
        Categories.collection.find {parent: @_id}, {sort: {order: 1}}
        
    findDescendats: ->
        resTwoLevelArr = @findChildren().map( (cat) -> cat.findDescendats())
        res = [].concat.apply([], resTwoLevelArr)
        res.push(@_id)
        res
        
    isLeaf: ->
        child = Categories.collection.findOne {parent: @_id}
        !child
        
    update: (name, comment, parent, order, collapsedByDefault) ->
        if not Categories.canUpdate()
            throw new Meteor.Error "permission-denied", "Can't not update category"
        Categories.collection.update _id: @_id,
            $set:
                name: name
                comment: comment
                parent: parent
                order: order
                collapsedByDefault: collapsedByDefault
                
    _collapsedKeyName: ->
        "categoryCollapsed_" + this._id
                
    collapsed: ->
        if not (Session.get(@_collapsedKeyName())?)
            if not (@collapsedByDefault?)
                @collapsedByDefault = false
            Session.set(@_collapsedKeyName(), @collapsedByDefault)
            return @collapsedByDefault
        Session.get(@_collapsedKeyName())
        
    invertCollapsed: ->
        if @collapsed()
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
    
    create: (name, comment, parent, order) ->
        if not @canCreate()
            throw new Meteor.Error "permission-denied", "Can't not create category"
        @collection.insert
            name: name
            comment: comment
            parent: parent
            order: order
            collapsedByDefault: false
            
    findTopLevel: ->
        @findRoot()?.findChildren()
        
    findRoot: ->
        @collection.findOne
            parent: ""
    
    findAll: ->
        @collection.find {}
        
    findById: (id)->
        @collection.findOne id
        
    collection: CategoriesCollection

@Categories = Categories
