class App extends App('landing')
  constructor: ->
    return [
      'landing.home'
      'landing.about'
    ]

class config extends Config('landing')
  constructor: ($stateProvider) ->
    $stateProvider.state 'landing',
      abstract: true
      views:
        '':
          templateUrl: 'frontend/frontpage/index.tpl.html'
          controller: 'HomeCtrl'
        'header@landing':
          templateUrl: 'common/frontend/header/header.tpl.html'
        'footer@landing':
          templateUrl: 'common/frontend/footer/footer.tpl.html'

class HomeCtrl extends Controller('landing')
  constructor: ($scope, titleService) ->
    titleService.setTitle 'Home'