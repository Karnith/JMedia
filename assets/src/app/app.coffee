class App extends App('JMedia')
  constructor: ->
    return [
      "ui.router"
      "ngAnimate"
      "oc.lazyLoad"
      "hj.gsapifyRouter"
      "ngSails"
      "ngMessages"
      "angularMoment"
      "ngLodash"
      "ui.bootstrap"
      "ngBootstrap"
      "ngDropzone"
      "ui.select2"
      "ngJcrop"
      "templates-app"
      "services"
      "models"
      "ngTable"
      'ngTouch'
      'ct.ui.router.extras'
      'ngSanitize'
      "directives"
      "auth"
      "landing"
#      "JMedia.header"
#      "JMedia.home"
#      "JMedia.about"
      "members"
    ]
class myAppConfig extends Config('JMedia')
  constructor: ($stateProvider, $urlRouterProvider, $locationProvider)->
    $urlRouterProvider.otherwise '/'
    $locationProvider.html5Mode true
class Run extends Run('JMedia')
  constructor: ->
    moment.locale "en"
class AppCtrl extends Controller('JMedia')
  constructor: ($scope, config, titleService)->
    titleService.setTitle 'Home'
    config.currentUser = window.currentUser