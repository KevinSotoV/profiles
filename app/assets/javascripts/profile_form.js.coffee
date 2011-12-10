#= require 'jquery.miniColors'

$('.color').miniColors
  change: ->
    $('.bg-selector .img').removeClass('selected')
    $('#profile_theme_attributes_bg_image').val('')

$('.bg-selector .img').click (e)->
  e = $(e.target)
  $('#profile_theme_attributes_bg_color_top').val('')
  $('.bg-selector .img').removeClass('selected')
  e.addClass('selected')
  $('#profile_theme_attributes_bg_image').val(e.data('filename'))
  $('#profile_theme_attributes_box_pos').val(e.data('box-pos'))

$('#profile_theme_attributes_bg_color_top').change (e)->
  unless $(e.target).val() == ''
    $('.bg-selector .img').removeClass('selected')
    $('#profile_theme_attributes_bg_image').val('')

$('#box_bg_opacity').slider
  value: $('#profile_theme_attributes_box_bg_opacity').val()*100
  change: (e, ui) ->
    $('#profile_theme_attributes_box_bg_opacity').val ui.value/100

$ ->
  if (img = $('.bg-selector .img.selected')).length > 0
    section = "#{img.data('image-type')}_images"
    $(".pills a[href=\"##{section}\"]").click()
  else
    $('.pills a[href="#color"]').click()
