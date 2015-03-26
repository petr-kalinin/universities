Meteor.publish 'universities', ->
    Universities.findAll()
