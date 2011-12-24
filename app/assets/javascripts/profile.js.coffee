$('#search-form').live 'submit', (e)->
  e.preventDefault()
  $.pjax
    container: '#aux'
    url: @action + '?' + $(@).serialize()

$("a[rel=tip]").twipsy
  offset: 10
  placement: 'below'
