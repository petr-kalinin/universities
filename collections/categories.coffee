categoriesSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true
  'parent':
    type: String
    index: true

Categories = new Mongo.Collection 'categories'
Categories.attachSchema categoriesSchema

_.extend Categories,
    create: (name, parent) ->
        Categories.insert
            name: name
            parent: parent


@CategoriesCollection = Categories
