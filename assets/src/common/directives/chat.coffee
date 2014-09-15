#/**
# * Chat: Angular Page Model
# *
# * Description: Chat Directive
# *
# *
# */
class App extends App('chat')
  constructor: ->
    return []
class chat extends Directive('chat')
  constructor: ->
    return {
    restrict: 'E'
    templateUrl: 'chat/index.tpl.html'
    }