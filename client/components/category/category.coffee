Template.category.events
    "submit": (event) ->
        name = event.target.text.value
        Categories.create name, this._id
        event.target.text.value = ""
        false

Template.category.helpers
    subCategory: ->
        this.findChildren()
