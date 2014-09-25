class App extends App('sailng')
  constructor: ->
    return [
      "ui.router"
      "ngSails"
      "angularMoment"
      "lodash"
      "ui.bootstrap"
      "templates-app"
      "services"
      "models"
      "ngTable"
      "directives"
      "auth"
      "sailng.header"
      "sailng.home"
      "sailng.about"
      "members"
    ]
class myAppConfig extends Config('sailng')
  constructor: ($stateProvider, $urlRouterProvider, $locationProvider)->
    $urlRouterProvider.otherwise '/'
    $locationProvider.html5Mode true
class Run extends Run('sailng')
  constructor: ->
    moment.locale "en"
class AppCtrl extends Controller('sailng')
  constructor: ($scope, config)->
    config.currentUser = window.currentUser