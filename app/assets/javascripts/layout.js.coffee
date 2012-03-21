window.setupScroll = ->
  navTopMax = 450
  navTopOffset = 30

  scrollMove = (event) ->
    top = $(window).scrollTop()
    $('body').css('background-position', "0 #{top / 2}px")
    navTop = top + navTopOffset
    if navTop >= navTopMax
      $('nav').css('position', 'absolute').css('top', "#{navTopMax}px")
    else
      $('nav').css('position', 'fixed').css('top', "#{navTopOffset}px")

  $(window).bind 'scroll', scrollMove
  scrollMove()
  $ -> $(window).scrollTop(400)
