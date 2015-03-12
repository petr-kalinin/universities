Template.comment.events
    "click .delete": ->
        CommentsCollection.remove this._id
