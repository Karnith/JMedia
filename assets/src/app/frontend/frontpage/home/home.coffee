class App extends App('landing.home')
  constructor: ->
    return []

class Config extends Config('landing.home')
  constructor: ($stateProvider)->
    $stateProvider.state 'landing.home',
      url: '/'
      views:
#        'header@landing':
#          templateUrl: 'common/frontend/header/header.tpl.html'
        'content':
          controller: 'HomeCtrl'
          templateUrl: 'frontend/frontpage/home/home.tpl.html'
#        'footer@landing':
#          templateUrl: 'common/frontend/footer/footer.tpl.html'
      data:
        ncyBreadcrumbLabel: 'Home'

class HomeCtrl extends Controller('landing.home')
  constructor: ($scope, titleService)->
    titleService.setTitle 'Home'