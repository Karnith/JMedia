#/**
# * userMenu: Angular Page Model
# *
# * Description: User menu with notifications
# *
# *
# */
class App extends App('userMenu')
  constructor: ->
    return []
class userMenu extends Directive('userMenu')
  constructor: ->
    return {
    restrict: 'E'
    templateUrl: 'menus/usermenu/index.tpl.html'
    }