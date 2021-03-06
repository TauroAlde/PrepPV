# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  if $("body").length && $("body").attr("data-signin") == "false"
    $(window).click (e) ->
      catchLeftClick(e)

    catchLeftClick = (event) ->
      if event.target == $('#open-hide')[0] or $('#open-hide').find(event.target).length
        $('#left-sidebar').toggleClass 'show-sidebar'
        #event.preventDefault()
      else
        $('#left-sidebar').removeClass 'show-sidebar'
      return

    catchRightClick = (event) ->
      if event.target == $('#right-sidebar-switch')[0] or $('#right-sidebar-switch').find(event.target).length
        #event.preventDefault()
        $('#right-sidebar').toggleClass 'show-right-sidebar'
      else if event.target == $('#close-sidebar')[0]
        #event.preventDefault()
        $('#right-sidebar').removeClass 'show-right-sidebar'
      else if event.target == $('#right-sidebar')[0] or $('#right-sidebar').find(event.target).length
        $('#right-sidebar').addClass 'show-right-sidebar'
      else
        $('#right-sidebar').removeClass 'show-right-sidebar'
      return

    if $("#chat").length
      window.chat = new Chat
  
    $(document).on "click", ".chat-link", (e)->
      e.preventDefault()
      window.chat.startNewChatFromPageLink(e.currentTarget)

    #setInterval -> 
    #  $.getScript("/messages_kpis")
    #, 10000
    
    $(".reports-timepicker").timepicker
      timeFormat: 'h:mm p'
      dynamic: false,
      dropdown: true,
      scrollbar: true

    $("#reports-segment-search").select2
      width: "100%"
      placeholder: 'Buscar por usuario o casilla'
      minimumInputLength: 3
      multiple: true
      include_hidden: false
      allowClear: true
      ajax:
        dataType: 'json'
        url: '/reports/segment'
        processResults: (data) ->
          items = []
          console.log data
          $.each data, (index, el)->
            items.push({ id: el.id, text: el.name, type: "segment" })
          { results: items }
      templateResult: (d) ->
        html = ""
        if d.id
          html = "<span class=\"badge-pill badge-info select2-badges\"><i class=\"fa fa-compass\"></i></span> <span>#{d.text}</span>"
        else
          html = "<span>#{d.text}</span>"
        $(html)
        #$(html)
      templateSelection: (d) ->
        $("<span class=\"badge-pill badge-info select2-badges\"><i class=\"fa fa-compass\"></i></span> <span>#{d.text}</span>")



  #$( document ).ajaxError ->
  #  $.notify("Ocurrió un error en el servidor, por favor contacte a su administrador", { globalPosition: "top center" });