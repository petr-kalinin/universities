Router.onRun ->
    yaCounter29787484?.hit Iron.Location.get().path
    @next();
