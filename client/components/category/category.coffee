Template.category.events
    "submit .new-category": (event) ->
        name = event.target.name.value
        comment = event.target.comment.value
        order = event.target.order.value
        Categories.create name, comment, this._id, order
        event.target.name.value = ""
        event.target.comment.value = ""
        event.target.order.value = ""
        false

    "submit .edit-category": (event) ->
        name = event.target.name.value
        comment = event.target.comment.value
        parent = event.target.parent.value
        order = event.target.order.value
        collapsedByDefault = (event.target.collapsedByDefault.value == "true")
        if not Categories.findById(parent)
            return false
        this.update name, comment, parent, order, collapsedByDefault
        false
        
    "click .showCreateNew": (event) ->
        if Session.equals("createNewCategory", true)
            Session.set("createNewCategory", false)
        else
            Session.set("createNewCategory", true)

Template.category.helpers
    subCategory: ->
        this.findChildren()
    showCreateNew: ->
        Session.equals("createNewCategory",true)
