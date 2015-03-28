Template.comment.events
    "click .delete": ->
        this.remove()

Template.comment.helpers
    authorName: ->
        UsersCollection.findOne(this.author)?.profile?.name
        
    canDelete: ->
        Meteor.userId() && Meteor.userId() == this.author
