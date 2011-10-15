$ ->
  # close alerts
  resource = location.pathname.match(/^\/profiles\/\d+/)[0]
  $('.alert-message .close').live 'click', ->
    id = $(@).parents('.alert-message').hide().attr('id')
    $.ajax("#{resource}/alerts/#{id}", {type: 'delete'}) if id
    false

  $('#aux .close, #aux .close-btn').live 'click', ->
    $(@).parents('#aux').empty()
    history.pushState({}, "profile", resource) if history.pushState
    false

  # pjax
  $('a[data-pjax]').pjax()
