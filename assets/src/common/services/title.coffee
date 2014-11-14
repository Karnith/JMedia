class App extends App('services.title')
  constructor: ->
    return []

class titleService extends Factory('services.title')
  constructor: ($document) ->
    suffix = title = " - JMedia Media Center"
    return {
    setSuffix: (s) ->
      suffix = s

    getSuffix: ->
      suffix

    setTitle: (t) ->
      if suffix isnt ""
        title = t + suffix
      else
        title = t
      $document.prop "title", title

    getTitle: ->
      $document.prop "title"
    }