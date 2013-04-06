$ ->
  # close alerts
  resource = $('body').data('profile-path')
  $('.alert-box').on 'click', '.close', ->
    id = $(@).parents('.alert-box').hide().attr('id')
    $.ajax("#{resource}/alerts/#{id}", {type: 'delete'}) if id
    false

  ## tooltips
  #$('.has-tooltip').tooltip
    #placement: 'right'
