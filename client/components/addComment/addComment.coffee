Template.addComment.events
    "keydown": (event) ->
        if (event.keyCode == 13)&&(event.ctrlKey)
            text = event.target.value
            Comments.create this, text, Users.currentUser()
            event.target.value = ""
            false
    "submit": (event) ->
        text = event.target.text.value
        Comments.create this, text, Users.currentUser()
        event.target.text.value = ""
        false
        
    "focus .new-comment": (event) ->
        Session.set('focusedComment', this._id)
        
    "blur .new-comment": (event) ->
        Session.set('focusedComment', undefined)

Template.addComment.helpers
    focused: ->
        Session.equals("focusedComment", this._id)

Template.addComment.rendered = ->
    autosize(document.querySelectorAll('textarea'));
    
    
