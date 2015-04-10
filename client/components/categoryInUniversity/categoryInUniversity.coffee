Template.categoryInUniversity.events
    "keydown": (event) ->
        if (event.keyCode == 13)&&(event.ctrlKey)
            text = event.target.value
            Reviews.create this.university, this.category, text, Users.currentUser()
            event.target.value = ""
            false
    "submit": (event) ->
        text = event.target.text.value
        Reviews.create this.university, this.category, text, Users.currentUser()
        event.target.text.value = ""
        false
    "click .collapse": (event) ->
        this.category.invertCollapsed()
        false

Template.categoryInUniversity.helpers
    subCategory: ->
        this.category.findChildren()
    isLeaf: ->
        this.category.isLeaf()
    isLeafOrCollapsed: ->
        this.category.isLeaf() or this.category.collapsed()
    reviews: ->
        Reviews.find this.university, this.category, this.category.collapsed()
    canCreate: ->
        Reviews.userCanCreate()
    collapseButtonDirection: ->
        if this.category.collapsed()
            "down"
        else
            "up"
    collapsed: ->
        this.category.collapsed()
    collapseTitle: ->
        if this.category.collapsed()
            "Развернуть"
        else
            "Свернуть"
        
        

Template.categoryInUniversity.rendered = ->
    autosize(document.querySelectorAll('textarea'));
#    document.querySelectorAll('textarea').autosize().show().trigger('autosize.resize');
