categoriesSchema = SimpleSchema.build SimpleSchema.timestamp,
  'name':
    type: String
    index: true
  'parent':
    type: String
    index: true

Categories = new Mongo.Collection 'categories'
Categories.attachSchema categoriesSchema

@CategoriesCollection = Categories
