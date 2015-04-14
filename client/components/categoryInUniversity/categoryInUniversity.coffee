Template.categoryInUniversity.events
    "keydown .new-review": (event) ->
        if (event.keyCode == 13)&&(event.ctrlKey)
            text = event.target.value
            Reviews.create this.university, this.category, text, Users.currentUser()
            event.target.value = ""
            false
    "submit .new-review": (event) ->
        text = event.target.text.value
        Reviews.create this.university, this.category, text, Users.currentUser()
        event.target.text.value = ""
        false
    "click .collapse": (event) ->
        this.category.toggleCollapsed()
        false
    "click .showReviews": (event) ->
        this.category.toggleShowReviews()
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
    hasReviews: ->
        Reviews.find this.university, this.category, this.category.collapsed()
            .count() > 0
    canCreate: ->
        Reviews.userCanCreate()
        
    collapsed: ->
        this.category.collapsed()
    collapseButtonDirection: ->
        if this.category.collapsed()
            "down"
        else
            "up"
    collapseTitle: ->
        if this.category.collapsed()
            "Развернуть"
        else
            "Свернуть"
            
    showReviews: ->
        this.category.showReviews()
    showReviewsButtonStatus: ->
        if this.category.showReviews()
            "close"
        else
            "open"
    showReviewsTitle: ->
        if this.category.showReviews()
            "Скрыть отзывы"
        else
            "Показать отзывы"
        
        

Template.categoryInUniversity.rendered = ->
    autosize(document.querySelectorAll('textarea'));
#    document.querySelectorAll('textarea').autosize().show().trigger('autosize.resize');
