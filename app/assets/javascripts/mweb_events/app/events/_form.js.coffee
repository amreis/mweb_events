$ ->

  if isOnPage('mweb_events-events', 'new') or isOnPage('mweb_events-events', 'edit')

    $('#start_on, #end_on').datetimepicker
      language: 'pt-BR'

    # Kind of a hack to show the arrows
    $('#start_on i, #end_on i').on 'click', (e) ->
      $('.icon-chevron-down').attr('class', 'fa fa-chevron-down')
      $('.icon-chevron-up').attr('class', 'fa fa-chevron-up')

    $("#event_time_zone").select2()

    opts =
      button: false
      autogrow:
         minHeight: 150
         maxHeight: 300

    editor = new EpicEditor(opts).load()
    editor.importFile('epiceditor', $('#event_description').text())

    $("#event_description").hide()

    editor.on 'update', ->
      $('#event_description').text(editor.exportFile())

    window.onresize = ->
      editor.reflow()
