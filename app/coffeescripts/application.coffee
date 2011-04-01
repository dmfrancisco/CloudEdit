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

class Document extends Backbone.Model
  url: ->
    base = "documents"

    if this.isNew()
      base
    else
      if base.charAt(base.length - 1) == "/"
        base + "" + this.id
      else
        base + "/" + this.id

class App.Collections.Documents extends Backbone.Collection
  model: Document
  url: '/documents'

class App.Views.Index extends Backbone.View
  initialize: ->
    this.render()

  render: ->
    $(this.el).html(JST.documents_collection(collection: this.collection))
    $("#app").html(this.el)

class App.Views.Edit extends Backbone.View
  events:
    "submit form": "save"

  initialize: ->
    _.bindAll this, "render"
    this.model.bind "change", this.render
    this.render()

  save: ->
    self = this
    message = if this.model.isNew()
      "Successfuly created!"
    else
      "Saved!"

    data = {  }

    this.model.save {
      title: this.$('[name=title]').val()
      body: this.$('[name=body]').val()
    },{
      success: (model, response) ->
        new App.Views.Notice message: message
        Backbone.history.saveLocation "documents/" + model.id

      error: ->
        new App.Views.Error()
    }

    false

  render: ->
    $(this.el).html(JST.document(model: this.model))
    $("#app").html(this.el)

    this.$("[name=title]").val(this.model.get("title"))

    this.delegateEvents()

window.Document = Document
window.App = App
