Router.onRun ->
    yaCounter29787484?.hit Iron.Location.get().path
    if ga?
        ga 'send', 'pageview', Iron.Location.get().path
    @next();
