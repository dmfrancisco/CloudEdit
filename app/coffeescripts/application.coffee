App =
  Views: {}
  Controllers: {}
  Collections: {}

  init: ->
    new App.Controllers.Documents()
    Backbone.history.start()

window.App = App
