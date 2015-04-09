Template.review.events
    "click .remove": ->
        this.review.remove()

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