Template.comment.events
    "click .remove": ->
        this.remove()

Template.comment.helpers
    canRemove: ->
        Meteor.userId() && Meteor.userId() == this.author
        
    author: ->
        Users.findById(this.author)
