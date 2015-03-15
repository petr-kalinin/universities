Template.categoryInUniversity.events
    "submit": (event) ->
        text = event.target.text.value
        CommentsCollection.insert
            category: this.category._id
            university: this.university
            author: Meteor.userId()
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
    userName: ->
        uId = Meteor.userId()
        UsersCollection.findOne(uId)?.profile.name
        

Template.categoryInUniversity.rendered = ->
    autosize(document.querySelectorAll('textarea'));
#    document.querySelectorAll('textarea').autosize().show().trigger('autosize.resize');
