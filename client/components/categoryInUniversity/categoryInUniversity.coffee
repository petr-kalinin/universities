Template.categoryInUniversity.events
    "keydown": (event) ->
        if (event.keyCode == 13)&&(event.ctrlKey)
            text = event.target.value
            CommentsCollection.insert
                category: this.category._id
                university: this.university
                author: Meteor.userId()
                text: text
            event.target.value = ""
            false;
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
        this.category.findChildren()
    isLeaf: ->
        this.category.isLeaf()
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
