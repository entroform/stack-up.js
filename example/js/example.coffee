stackgrid = new Stackgrid

window.onload = ->
  stackgrid.config.columnWidth = 220
  stackgrid.config.gutter = 20
  stackgrid.config.isFluid = false
  grid.update()
  stackgrid.config.move = (item, left, top, callback) ->
    Velocity item,
      left: left
      top: top,
      queue: false
      duration: 200,
      callback

  stackgrid.config.scale = (container, width, height, callback) ->
    Velocity container,
      height: height
      width: width,
      queue: false
      duration: 200,
      callback

  stackgrid.initialize '.grid-container', '.grid-item'
  return

grid =
  $container: undefined
  $items: undefined

grid.update = ->
  grid.$container = document.querySelector '.grid-container'
  grid.$items = document.querySelectorAll '.grid-item'
  item.addEventListener 'click', grid.removeItem for item in grid.$items
  return
grid.update()

grid.removeItem = ->
  grid.$container.removeChild this
  stackgrid.reset()
  stackgrid.restack()
  return

grid.append = (url) ->
  gridItem = document.createElement 'div'
  gridItem.setAttribute 'class', 'grid-item'
  gridItem.innerHTML =  "<img src=\"#{url}\" alt=\"\">"
  onimgload url, ->
    grid.$container.appendChild gridItem
    grid.update()
    Velocity gridItem, scale: 0, 1, ->
      stackgrid.reset()
      stackgrid.restack()
    Velocity gridItem, scale: 1, 200
  return

$buttons = document.getElementsByClassName 'control-button'
$button.addEventListener 'click', ( (event) -> event.preventDefault() ) for $button in $buttons
buttons = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen']
button = {}
button[i] = document.querySelector ".control-button.-#{i}" for i in buttons

button.one.onclick = (-> grid.append 'img/short.jpg' )
button.two.onclick = (-> grid.append 'img/medium.jpg' )
button.three.onclick = (-> grid.append 'img/tall.jpg' )

button.four.onclick = ->
  stackgrid.config.gutter = 20
  stackgrid.restack()
  return

button.five.onclick = ->
  stackgrid.config.gutter = 0
  stackgrid.restack()
  return

button.six.onclick = ->
  stackgrid.config.layout = 'ordinal'
  stackgrid.restack()
  return

button.seven.onclick = ->
  stackgrid.config.layout = 'optimized'
  stackgrid.restack()
  return

button.eight.onclick = ->
  stackgrid.config.isFluid = true
  stackgrid.restack()
  return

button.nine.onclick = ->
  stackgrid.config.isFluid = false
  stackgrid.restack()
  return

button.ten.onclick = ->
  grid.$container.removeChild item for item in grid.$items
  stackgrid.reset()
  stackgrid.restack()
  return

button.eleven.onclick = ->
  stackgrid.config.columnWidth = 320
  stackgrid.reset()
  stackgrid.restack()
  return

button.twelve.onclick = ->
  stackgrid.config.columnWidth = 220
  stackgrid.reset()
  stackgrid.restack()
  return

button.thirteen.onclick = ->
  stackgrid.config.columnWidth = 120
  stackgrid.reset()
  stackgrid.restack()
  return
