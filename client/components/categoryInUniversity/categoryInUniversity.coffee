Template.categoryInUniversity.events
    "keydown": (event) ->
        if (event.keyCode == 13)&&(event.ctrlKey)
            text = event.target.value
            Comments.create this.university, this.category, text, Meteor.user()
            event.target.value = ""
            false
    "submit": (event) ->
        text = event.target.text.value
        Comments.create this.university, this.category, text, Meteor.user()
        event.target.text.value = ""
        false

Template.categoryInUniversity.helpers
    subCategory: ->
        this.category.findChildren()
    isLeaf: ->
        this.category.isLeaf()
    comments: ->
        Comments.find this.university, this.category
    userName: ->
        uId = Meteor.userId()
        UsersCollection.findOne(uId)?.profile.name
        

Template.categoryInUniversity.rendered = ->
    autosize(document.querySelectorAll('textarea'));
#    document.querySelectorAll('textarea').autosize().show().trigger('autosize.resize');
