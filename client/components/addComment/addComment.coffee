Template.addComment.events
    "keydown": (event) ->
        if (event.keyCode == 13)&&(event.ctrlKey)
            text = event.target.value
            Comments.create this.university, this.category, text, Users.currentUser()
            event.target.value = ""
            false
    "submit": (event) ->
        text = event.target.text.value
        Comments.create this.university, this.category, text, Users.currentUser()
        event.target.text.value = ""
        false
        
    "focus .new-comment": (event) ->
        Session.set('focused', this.category._id)
        
    "blur .new-comment": (event) ->
        Session.set('focused', undefined)

Template.addComment.helpers
    focused: ->
        Session.equals("focused", this.category._id)

Template.addComment.rendered = ->
    autosize(document.querySelectorAll('textarea'));
    
    
