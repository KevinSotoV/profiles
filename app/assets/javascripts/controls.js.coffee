# tabs
$(document).on 'click', 'ul.nav-tabs li a, ul.nav-pills li a', (e) ->
  e.preventDefault()
  $(this).tab('show')

$ ->
  # close alerts
  resource = $('body').data('profile-path')

  $(document).on 'click', '.alert-block .close', ->
    id = $(@).parents('.alert-block').hide().attr('id')
    $.ajax("#{resource}/alerts/#{id}", {type: 'delete'}) if id
    false

  $(document).on 'click', '#aux .close, #aux .close-btn', ->
    $(@).parents('#aux').empty()
    history.pushState({}, "profile", resource) if history.pushState
    false

  # pjax
  $('a[data-pjax]').pjax()
