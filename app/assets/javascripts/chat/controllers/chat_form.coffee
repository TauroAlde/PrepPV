class @ChatForm
  constructor: (chat)->
    @el = chat.el.find("#chat-form")
    @chat = chat
    @render()

  render: ()->
    @el.attr("action", @currentChatPath())
    if !@alreadySubmitBind
      @alreadySubmitBind = true
      @bindMessagesFileUploader() 
      @bindOnSubmit()

  bindMessagesFileUploader: ->
    form = @ 
    #if @el.hasClass("jquery-fileupload-initialized")
    #  @el.fileupload('destroy')
    #  @el.removeClass("jquery-fileupload-initialized")
    #if @chat.currentIsSegmentMessage() || @chat.currentIsUserMessage()
    #@el.addClass("jquery-fileupload-initialized")
    @el.fileupload
      dataType: 'json'
      fileInput: $('#fileupload-evidence')
      limitMultiFileUploads: 1
      autoUpload: true,
      url: form.el.attr("action")
      progressall: (e, data) ->
        progress_bar_container = form.chat.el.find("#progress")
        progress_bar_container.removeClass("d-none")
        progress = parseInt(data.loaded / data.total * 100, 10);
        progress_bar_container.find('.progress-bar').attr("aria-valuenow", progress );
        progress_bar_container.find('.progress-bar').css("width", progress + "%" );
      add: (e, data)->
        console.log("add")
        data.url = form.el.attr("action")
        data.process().done -> data.submit()
      done: (e, data)->
        form.resetProgressBar()
        if data.result.errors
          if data.result.errors[0] == "Evidences no es válido"
            $.notify("Revise el formáto de la imagen, solo se permiten jpg y png", { globalPosition: "top center" });
          else
            $.notify(data.result.errors.join(", "), { globalPosition: "top center" });
        else
          form.addNewMessage(data.result)
      fail: (e, data) ->
        console.log "form fail"
        form.resetProgressBar()
        #$.notify("Información guardada", { globalPosition: "top center", className: 'success' });
        $.notify(data.errorThrown + ": " + Object.values(data.messages).join(", "), { globalPosition: "top center" });
      submit: (e, data) ->
        if !form.canSubmit() then return false
        console.log "form submit"
      send: (e, data) =>
        console.log "form send"

  resetProgressBar: ->
    @chat.el.find('.progress-bar').attr("aria-valuenow", 0 );
    @chat.el.find('.progress-bar').css("width", 0 );
    @chat.el.find("#progress").addClass("d-none")

  currentChatPath: ->
    if @chat.currentIsChatRoom()
      @chat.current.responsePath()
    else
      "#"

  canSubmit: ->
    !(@el.attr("action") == "#" || !@text)

  bindOnSubmit: ->
    @el.submit (e) =>
      e.preventDefault()
      if @canSubmit()
        $.post
          url: @el.attr("action")
          data: @el.serialize()
          datatype: "JSON"
          success: (messageData, textStatus, jqXHR) =>
            @clearText()
            @addNewMessage(messageData)
      return

  addNewMessage: (messageData)->
    message = new @chat.current.messageClass(messageData, @chat, @chat.current.pool, @chat.current)
    @chat.current.messages.push(message)
    @chat.current.scrolled = false
    @chat.current.renderMessages()

  clearText: ->
    @el.find("#message-text").val("")

  text: ->
    @el.find("#message-text").val()

  disable: ->
    $("#form-fieldset").attr("disabled", "true")
  enable: ->
    $("#form-fieldset").attr("enabled", "true")