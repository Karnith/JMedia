class App extends App('landing.about')
  constructor: ->
    return []

class config extends Config('landing.about')
  constructor: ($stateProvider) ->
    $stateProvider.state 'landing.about',
      url: '/about'
      views:
        'breadcrumb':
          templateUrl: 'common/breadcrumb/breadcrumb.tpl.html'
        'content':
          controller: 'AboutCtrl'
          templateUrl: 'frontend/frontpage/about/about.tpl.html'
      ncyBreadcrumb:
        label: 'About',
        parent: 'landing.home'
#      data:

class AboutCtrl extends Controller('landing.about')
  constructor: ($scope, titleService) ->
    titleService.setTitle 'About'
