Template.universityShort.events
    "click .delete": ->
        comments = CommentsCollection.find university: this._id
        comments.forEach (c) -> CommentsCollection.remove c._id
        UniversitiesCollection.remove this._id

