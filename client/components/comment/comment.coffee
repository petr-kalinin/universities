Template.comment.events
    "click .delete": ->
        this.remove()

Template.comment.helpers
    canDelete: ->
        Meteor.userId() && Meteor.userId() == this.author
        
    author: ->
        Users.findById(this.author)
