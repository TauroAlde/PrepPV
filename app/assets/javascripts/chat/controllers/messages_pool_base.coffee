class @MessagesPoolBase
  #@resumeSelector = undefined  # variables globales para la clase para poder tener un valor
  #@path = undefined            # default o saber lo que hay que llenar al llamar al constructor
  #@el = undefined
  selector: undefined
  type: undefined
  chatRoomControllerClass: undefined

  constructor: (chat, poller)->
    @chat = chat
    @el = $(@selector)
    @path = "/#{@type}_messages.json"
    @render(poller)

  render: (poller)->
    @chatRooms = []
    @startLoadingIcon() if !poller
    $.get
      url: @path
      datatype: "JSON"
      success: (data, textStatus, jqXHR) =>
        html = []
        $.each data, (index, el) =>
          chatRoom = new @chatRoomControllerClass(el, @chat, @)
          @chatRooms.push(chatRoom)
          html.push chatRoom.renderRow()
        if @chat.current == @chat
          @stopLoadingIcon()
          @el.html(html)

  startLoadingIcon: ->
    @el.html('<div class="m-t5 row justify-content-center align-items-center h-100"><div class="col-auto"><div class="loader"></div></div></div>')

  stopLoadingIcon: ->
    @el.html("")

  renderMessages: (messages) ->
    html = []
    $.each messages, (index, message) ->
      html.push(message.render())
    @el.html(html)

  openNewChatFor: (id)->
    @chat.clearPoller() # stop the poller to open a new chat
    $.get
      url: "/#{@type}_messages/new.json"
      data: { "#{@type}_id": id }
      datatype: "JSON"
      success: (data, textStatus, jqXHR) =>
        chatRoom = new @chatRoomControllerClass(data, @chat, @)
        @chatRooms.push(chatRoom)
        @chat.current = chatRoom
        chatRoom.render()


  

  #startNewChat: (messageClass, params)->
  #  new_message_list = new messageClass("", @chat, @, params)
  #  @resumes.push(new_message_list)
  #  new_message_list.render()
  #
  #newResumesList: ->
  #  newResumes = []
  #  $.each @resumes, (index, messageResume) ->
  #    if messageResume.id.split("?")[0] == "new" then newResumes.push(messageResume)
  #  newResumes