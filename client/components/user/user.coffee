Template.user.helpers
    emailWorking: ->
        @email()?.verified
        
    emailHint: ->
        if @email()?
            "Email адрес не подтвержден"
        else
            "Email адрес не указан"
