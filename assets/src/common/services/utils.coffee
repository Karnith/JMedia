class App extends App('services.utils')
  constructor: ->
    return []

class utils extends Service('services.utils')
  constructor: (lodash, config)->
    return {
      prepareUrl: (uriSegments) ->
        if lodash.isNull(config.apiUrl)
          apiUrl = "api"
        else
          apiUrl = config.apiUrl
        apiUrl + "/" + uriSegments
      showDatetime: (string, format) ->
        moment(string).fromNow()
    }