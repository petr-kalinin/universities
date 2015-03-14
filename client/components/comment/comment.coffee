Template.comment.events
    "click .delete": ->
        if Meteor.userId() == this.author
            CommentsCollection.remove this._id

Template.comment.helpers
    authorName: ->
        UsersCollection.findOne(this.author)?.profile?.name
