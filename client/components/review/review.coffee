Template.review.events
    "click .remove": ->
        this.review.remove()
        false
    "click .edit": ->
        this.review.toggleIsEdited()
    "focus .edit-review": (event) ->
        Session.set('focusedReview', this.review._id)
    "blur .edit-review": (event) ->
        Session.set('focusedReview', undefined)
    "keydown .edit-review": (event) ->
        if (event.keyCode == 13)&&(event.ctrlKey)
            text = event.target.value
            this.review.toggleIsEdited()
            this.review.update text
            false
    "submit .edit-review": (event) ->
        text = event.target.text.value
        this.review.toggleIsEdited()
        this.review.update text
        false

Template.review.helpers
    formattedCreatedDate: ->
        moment(this.review.createdDate()).format('D.MM.YYYY')
        
    university: ->
        @review.getUniversity()
        
    universityName: ->
        if @review.getUniversity()
            @review.getUniversity().name
        else 
            ""
    categoryName: ->
        if @review.getCategory()
            @review.getCategory().name
        else
            ""
    focused: ->
        Session.equals("focusedReview", this.review._id)
        
    editHelper: ->
        Meteor.defer (=>
            textarea = $("#review_" + @review._id)
            textarea.focus()
            autosize(textarea))
        
    needCategory: ->
        (not (@showAll)) and (@review.category != @category?._id) and (@showCategory)
    
    numComments: ->
        Comments.find(@review).count()