Template.review.events
    "click .remove": ->
        this.remove()

Template.review.helpers
    formattedCreatedDate: ->
        moment(this.createdDate()).format('D.MM.YYYY')
