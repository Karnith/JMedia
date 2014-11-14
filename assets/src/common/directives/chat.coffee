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
    templateUrl: 'services/chat/chat.tpl.html'
    }