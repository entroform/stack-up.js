# Website

$window = $ window
$document = $ document

grid =
  wrapper: $ '.grid-wrapper'
  item: $ '.grid-item'

grid.wrapper.hide()

buttons = $ '.control-button'
button =
  one: $ '.control-button.one'
  two: $ '.control-button.two'
  three: $ '.control-button.three'
  four: $ '.control-button.four'
  five: $ '.control-button.five'
  six: $ '.control-button.six'
  seven: $ '.control-button.seven'
  eight: $ '.control-button.eight'
  nine: $ '.control-button.nine'
  ten: $ '.control-button.ten'
  eleven: $ '.control-button.eleven'
  twelve: $ '.control-button.twelve'
  bottom_one: $ '.control-button.bottom-one'
input =
  one: $ '.control-input.one'

append = (url) ->
  img = $ "<div class=\"grid-item\"><img src=\"#{url}\"></div>"
  wrapper = grid.wrapper
  $.imgload url, ->
    img.appendTo grid.wrapper
    callback = ->
    $.stackgrid.append img, callback
  return

$window.on 'load', ->
  grid.wrapper.show().fadeIn()
  $.stackgrid '.grid-wrapper', '.grid-item',
    move: (element, left, top, callback) ->
      element.stop().velocity
        left: left
        top: top
      , 500, ->
        callback()
      return
    scale: (element, height, width, callback) ->
      element.stop().velocity
        height: height
        width: width
      , ->
        callback()
      return

  $document.on 'click', '.grid-item', ->
    $this = $ this
    $this.remove()
    $.stackgrid.restack()
    return

  button.bottom_one.on 'click', ->
    url = input.one.val()
    append url
    input.one.val ''
    return

  buttons.on 'click', (event) ->
    event.preventDefault()
    return

  button.one.on 'click', ->
    url = 'img/small.png'
    append url
    return

  button.two.on 'click', ->
    url = 'img/medium.png'
    append url
    return

  button.three.on 'click', ->
    url = 'img/large.png'
    append url
    return

  button.four.on 'click', ->
    $.stackgrid.config.gutter = 20
    $.stackgrid.restack()
    return

  button.five.on 'click', ->
    $.stackgrid.config.gutter = 0
    $.stackgrid.restack()
    return

  button.six.on 'click', ->
    $.stackgrid.config.is_optimized = true
    $.stackgrid.restack()
    return

  button.seven.on 'click', ->
    $.stackgrid.config.is_optimized = false
    $.stackgrid.restack()
    return

  button.eight.on 'click', ->
    $.stackgrid.config.is_fluid = true
    $.stackgrid.restack()
    return

  button.nine.on 'click', ->
    $.stackgrid.config.is_fluid = false
    $.stackgrid.restack()
    return

  button.ten.on 'click', ->
    $('.grid-item').remove()
    $.stackgrid.reset()
    $.stackgrid.restack()
    return

  button.eleven.on 'click', ->
    $.stackgrid.config.column_width = 320
    $.stackgrid.reset()
    $.stackgrid.restack()
    return

  button.twelve.on 'click', ->
    $.stackgrid.config.column_width = 200
    $.stackgrid.reset()
    $.stackgrid.restack()
    return
