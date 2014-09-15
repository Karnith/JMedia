class App extends App('membersCenter')
  constructor: ->
    return []

class config extends Config('membersCenter')
  constructor: ($stateProvider) ->
    $stateProvider.state "members",
      url: "/members"
      views:
        main:
          controller: "MembersCenterCtrl"
          templateUrl: "members/memberscenter/index.tpl.html"

class MembersCenterCtrl extends Controller('membersCenter')
  constructor: ($scope, titleService) ->
    titleService.setTitle "Members"