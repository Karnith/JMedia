class App extends App('login')
  constructor: ->
    return []

class config extends Config('login')
  constructor: ($stateProvider) ->
    $stateProvider.state "login",
      url: "/login"
      views:
        main:
          controller: "LoginCtrl"
          templateUrl: "auth/login.tpl.html"

class LoginCtrl extends Controller('login')
  constructor: ($scope, titleService) ->
    titleService.setTitle "Login"