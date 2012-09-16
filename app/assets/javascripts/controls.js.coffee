$ ->
  # close alerts
  resource = $('body').data('profile-path')
  $('.alert-message .close').live 'click', ->
    id = $(@).parents('.alert-message').hide().attr('id')
    $.ajax("#{resource}/alerts/#{id}", {type: 'delete'}) if id
    false

  ## tooltips
  #$('.has-tooltip').tooltip
    #placement: 'right'
