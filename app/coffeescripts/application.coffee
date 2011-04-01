App =
  Views: {}
  Controllers: {}
  Collections: {}

  init: ->
    new App.Controllers.Documents()
    Backbone.history.start()

class App.Controllers.Documents extends Backbone.Controller
  routes:
    "documents/:id": "edit"
    "": "index"
    "new": "newDoc"

  edit: (id) ->
    document = new Document(id: id)

    document.fetch
      success: (model, resp) ->
        new App.Views.Edit(model: document)
      error: ->
        new Error(message: "")
        window.location.hash = "#"

  index: ->
    documents = new App.Collections.Documents()

    documents.fetch
      success: ->
        new App.Views.Index collection: documents
      error: ->
        new Error message: "Error loading documents."

  newDoc: ->
    new App.Views.Edit(model: new Document())

window.App = App
