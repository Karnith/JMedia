#/**
# * Main Menu: Angular Page Model
# *
# * Description: Main Menu for app
# *
# *
# */
class App extends App('mainMenu')
  constructor: ->
    return []
class mainMenu extends Directive('mainMenu')
  constructor: ->
    return {
      restrict: 'E'
      templateUrl: 'menus/mainmenu/index.tpl.html'
    }