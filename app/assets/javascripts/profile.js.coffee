$(document).on 'submit', '#search-form', (e)->
  e.preventDefault()
  $.pjax
    container: '#aux'
    url: @action + '?' + $(@).serialize()
