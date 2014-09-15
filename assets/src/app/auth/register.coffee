#/**
# * register: Angular Page Model
# *
# * Description: Registration form
# *
# *
# */
class App extends App('register')
  constructor: ->
    return []

class config extends Config('register')
  constructor: ($stateProvider) ->
    $stateProvider.state 'register',
      url: "/register"
      views:
        main:
          controller: "RegisterCtrl"
          templateUrl: "auth/register.tpl.html"

class RegisterCtrl extends Controller('register')
  constructor: ($scope, titleService) ->
    titleService.setTitle 'Members Registration'