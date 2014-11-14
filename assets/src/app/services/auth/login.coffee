class App extends App('login')
  constructor: ->
    return []

class config extends Config('login')
  constructor: ($stateProvider) ->
    $stateProvider.state "home.login",
      url: "login"
      views:
        'content@':
          controller: "LoginCtrl"
          templateUrl: "services/auth/login.tpl.html"

class LoginCtrl extends Controller('login')
  constructor: ($scope, titleService) ->
    titleService.setTitle "Login"