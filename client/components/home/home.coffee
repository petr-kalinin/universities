Template.home.helpers
    universities: ->
        Universities.findAll(true)
        
    canCreate: ->
        Universities.canCreate()

Template.home.created = ->
    if Accounts._verifyEmailToken
        Accounts.verifyEmail Accounts._verifyEmailToken, (err) ->
            if err != null 
                if err.message == 'Verify email link expired [403]'
                    console.log 'Sorry this verification link has expired.'
            else 
                console.log 'Thank you! Your email address has been confirmed.'
