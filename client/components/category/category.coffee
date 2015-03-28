Template.category.events
    "submit": (event) ->
        name = event.target.text.value
        Categories.create
            parent: this._id,
            name: name
        event.target.text.value = ""
        false;

Template.category.helpers
    subCategory: ->
        this.findChildren()
