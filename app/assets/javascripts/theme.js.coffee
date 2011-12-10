window.removeOldThemeStylesheet = (newLink) ->
  if newLink[0].sheet.cssRules.length > 0
    $('.theme-stylesheet.old').remove()
  else
    b = -> window.removeOldThemeStylesheet(newLink)
    setTimeout b, 250
