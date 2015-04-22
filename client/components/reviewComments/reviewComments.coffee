Template.reviewComments.helpers
    comments: ->
        Comments.find(this)
        
    universityName: ->
        this.getUniversity().name

    categoryName: ->
        this.getCategory().name

    canCreate: ->
        Comments.userCanCreate()