Template.comment.events
    "click .delete": ->
        CommentsCollection.remove this._id

Template.comment.helpers
    authorName: ->
        UsersCollection.findOne(this.author)?.profile?.name
