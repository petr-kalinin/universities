Template.category.events
    "submit .new-category": (event) ->
        name = event.target.name.value
        comment = event.target.comment.value
        Categories.create name, comment, this._id
        event.target.name.value = ""
        event.target.comment.value = ""
        false

    "submit .edit-category": (event) ->
        name = event.target.name.value
        comment = event.target.comment.value
        parent = event.target.parent.value
        console.log parent
        if not Categories.findById(parent)
            console.log "12"
            return false
        this.update name, comment, parent
        false

Template.category.helpers
    subCategory: ->
        this.findChildren()
