Template.universityShort.events
    "click .remove": ->
        this.remove()
        false

Template.universityShort.helpers
    reviewsNumber: ->
        Reviews.findByUniversity this
            .count()
