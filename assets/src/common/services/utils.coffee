class App extends App('services.utils')
  constructor: ->
    return [
      'lodash'
    ]

class utils extends Service('services.utils')
  constructor: (lodash, config)->
    return {
      prepareUrl: (uriSegments) ->
        if lodash.isNull(config.apiUrl)
          apiUrl = "http://localhost:1337"
        else
          apiUrl = config.apiUrl
        apiUrl + "/" + uriSegments
      showDatetime: (string, format) ->
        moment(string).fromNow()
    }