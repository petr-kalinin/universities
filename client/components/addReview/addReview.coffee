Template.addReview.events
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
        
    "focus .new-review": (event) ->
        Session.set('focused', this.category._id)
        
    "blur .new-review": (event) ->
        Session.set('focused', undefined)

Template.addReview.helpers
    focused: ->
        Session.equals("focused", this.category._id)

Template.addReview.rendered = ->
    autosize(document.querySelectorAll('textarea'));
    
    
