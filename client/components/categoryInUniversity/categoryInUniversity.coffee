Template.categoryInUniversity.events
    "submit": (event) ->
        text = event.target.text.value
        CommentsCollection.insert
            category: this.category._id
            university: this.university
            text: text
        event.target.text.value = ""
        false;

Template.categoryInUniversity.helpers
    subCategory: ->
        CategoriesCollection.find parent: this.category._id
    isLeaf: ->
        found = CategoriesCollection.findOne parent: this.category._id # better use count()? on server?
        !found
    comments: ->
        if this.university
            CommentsCollection.find 
                "university": this.university 
                category: this.category._id
        else
            false

