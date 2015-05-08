Template.categoryList.helpers
    subCategory: ->
        this.category.findChildren()
        
Template.categoryList.events
    'click .internalLink': (e,tmpl) ->
        e.preventDefault()
        location = '#' + e.target.href.split('#')[1]
        $('html, body').animate
            scrollTop: $(location).offset().top
        , 600
