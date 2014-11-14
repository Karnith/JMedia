class App extends App('members.dash')
  constructor: ->
    return []
class config extends Config('members.dash')
  constructor: ($stateProvider) ->
    $stateProvider.state 'members.dash',
      url: ''
      views:
        'breadcrumb':
          templateUrl: 'common/breadcrumb/breadcrumb.tpl.html'
        'content':
          controller: 'MembersDashCtrl'
          templateUrl: 'frontend/members/membersdash/dash.tpl.html'
      data:
        ncyBreadcrumbLabel: 'Dashboard'
class MembersDashCtrl extends Controller('members.dash')
  constructor: ($scope, titleService) ->
    titleService.setTitle 'Members Dashboard'