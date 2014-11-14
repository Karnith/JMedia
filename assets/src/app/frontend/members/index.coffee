class App extends App('members')
  constructor: ->
    return [
      'members.dash'
      'members.users'
    ]

class config extends Config('members')
  constructor: ($stateProvider) ->
    $stateProvider.state 'members',
      url: '/home'
      abstract: true
      views:
        '':
          templateUrl: 'frontend/members/index.tpl.html'
          controller: 'MembersCtrl'
#        'membersheader@members':
#          templateUrl: 'common/members/header/header.tpl.html'
        'menu@members':
          templateUrl: 'menus/mainmenu/mainmenu.tpl.html'
        'usermenu@members':
          templateUrl: 'menus/usermenu/usermenu.tpl.html'
        'chat@members':
          templateUrl: 'services/chat/chat.tpl.html'
        'footer@members':
          templateUrl: 'common/members/footer/footer.tpl.html'
#      resolve:
#        users: ($ocLazyLoad)->
#          return $ocLazyLoad.load(
#            name: 'members.users'
#            files: ['src/app/frontend/members/users/user.js']
#          )

class MembersCtrl extends Controller('members')
  constructor: ($scope, titleService) ->
    titleService.setTitle 'Members Home'