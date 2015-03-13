Template.university.events
    "submit .new-comment": (event) ->
        name = event.target.text.value
        CommentsCollection.insert
            university: this._id,
            text: name
        event.target.text.value = ""
        false;

Template.university.helpers
    categories: ->
        root = CategoriesCollection.findOne parent: ""
        if root
            CategoriesCollection.find parent: root._id
        else
            false

