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
                
    _booleanPropertyName: (name) ->
        "category_" + name + "_" + this._id
        
    _booleanProperty: (name, def) ->
        if not (Session.get(@_booleanPropertyName(name))?)
            if not (def?)
                def = false
            Session.set(@_booleanPropertyName(name), def)
            return def
        Session.get(@_booleanPropertyName(name))
        
    _toggleBooleanProperty: (name, def) ->
        if @_booleanProperty(name, @collapsedByDefault)
            Session.set(@_booleanPropertyName(name), false)
        else 
            Session.set(@_booleanPropertyName(name), true)
                
    collapsed: ->
        @_booleanProperty("collapsed", @collapsedByDefault)
        
    toggleCollapsed: ->
        @_toggleBooleanProperty("collapsed", @collapsedByDefault)
        
    showReviews: ->
        @_booleanProperty("showReviews", true)
        
    toggleShowReviews: ->
        @_toggleBooleanProperty("showReviews", true)

        
        
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
