Template.category.events
    "submit": (event) ->
        name = event.target.text.value
        CategoriesCollection.insert
            parent: this._id,
            name: name
        event.target.text.value = ""
        false;

Template.category.helpers
    subCategory: ->
        CategoriesCollection.find parent: this._id
        #CommentsCollection.find university: Router.current().setId
