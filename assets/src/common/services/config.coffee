class App extends App('services.config')
  constructor: ->
    return []

class config extends Service('services.config')
  constructor: (lodash) ->
    # private vars here if needed
    return {
      siteName: "MEANS Seed"
      # no trailing slash!
      siteUrl: "/"
      apiUrl: "/api"
      currentUser: false
    }