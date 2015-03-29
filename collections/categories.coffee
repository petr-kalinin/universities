categoriesSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true
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

Categories =
    create: (name, parent) ->
        @collection.insert
            name: name
            parent: parent
            
    findTopLevel: ->
        @collection.find
            parent: @findRoot()?._id
        
    findRoot: ->
        @collection.findOne
            parent: ""
    
    findAll: ->
        @collection.find {}
        
    collection: CategoriesCollection

@Categories = Categories
