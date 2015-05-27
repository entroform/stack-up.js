# example.coffee
stackgrid = new Stackgrid

window.onload = ->
  stackgrid.config.columnWidth = 220
  stackgrid.config.gutter = 20
  stackgrid.config.isFluid = false
  stackgrid.config.layout = 'optimized'
  grid.update()
  stackgrid.config.itemMove = (item, left, top, callback) ->
    Velocity item,
      left: left
      top: top,
      queue: false
      duration: 200,
      callback
  stackgrid.config.containerScale = (container, width, height, callback) ->
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
  columnWidth: 220
  gutter: 20
  isFluid: false
  layout: 'optimized'

grid.update = ->
  @$container = document.querySelector '.grid-container'
  @$items = document.querySelectorAll '.grid-item'
  item.addEventListener 'click', @removeItem for item in @$items
  return

grid.removeItem = ->
  Velocity this, scale: 0, 300, =>
    grid.$container.removeChild this
    stackgrid.reset()
    stackgrid.restack()
  return

grid.append = (url) ->
  gridItem = document.createElement 'div'
  gridItem.setAttribute 'class', 'grid-item'
  gridItem.innerHTML =  "<img src=\"#{url}\" alt=\"\">"
  onimgload url, =>
    @$container.appendChild gridItem
    @update()
    Velocity gridItem, scale: 0, 1, ->
      stackgrid.append gridItem
    Velocity gridItem, scale: 1, 200
  return

$buttons = document.getElementsByClassName 'control-button'
$button.addEventListener 'click', ( (event) -> event.preventDefault() ) for $button in $buttons
buttons = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
button = {}
button[i] = document.querySelector ".control-button.-#{i}" for i in buttons

# Append image.
button.one.onclick = (-> grid.append 'img/short.jpg' )
button.two.onclick = (-> grid.append 'img/medium.jpg' )
button.three.onclick = (-> grid.append 'img/tall.jpg' )

# Gutter toggle.
button.four.onclick = ->
  if grid.gutter is 20
    this.innerHTML = 'Gutter - 40'
    grid.gutter = 40
    stackgrid.config.gutter = 40
  else if grid.gutter is 40
    this.innerHTML = 'Gutter - 0'
    grid.gutter = 0
    stackgrid.config.gutter = 0
  else
    this.innerHTML = 'Gutter - 20'
    grid.gutter = 20
    stackgrid.config.gutter = 20
  stackgrid.restack()
  return

# Layout toggle.
button.five.onclick = ->
  if grid.layout is 'ordinal'
    this.innerHTML = 'Layout - optimized'
    grid.layout = 'optimized'
    stackgrid.config.layout = 'optimized'
  else
    this.innerHTML = 'Layout - ordinal'
    grid.layout = 'ordinal'
    stackgrid.config.layout = 'ordinal'
  stackgrid.restack()
  return

# Fluid toggle.
button.six.onclick = ->
  if grid.isFluid
    this.innerHTML = 'isFluid - false'
    grid.isFluid = false
    stackgrid.config.isFluid = false
  else
    this.innerHTML = 'isFluid - true'
    grid.isFluid = true
    stackgrid.config.isFluid = true
  stackgrid.restack()
  return

# Column toggle.
button.seven.onclick = ->
  if grid.numberOfColumns is 3
    this.innerHTML = 'numberOfColumns - 4'
    grid.numberOfColumns = 4
    stackgrid.config.numberOfColumns = 4
  else
    this.innerHTML = 'numberOfColumns - 3'
    grid.numberOfColumns = 3
    stackgrid.config.numberOfColumns = 3
  stackgrid.restack()
  return

# Width toggle.
button.eight.onclick = ->
  if grid.columnWidth is 320
    this.innerHTML = 'columnWidth - 220'
    grid.columnWidth = 220
    stackgrid.config.columnWidth = 220
  else if grid.columnWidth is 220
    this.innerHTML = 'columnWidth - 120'
    grid.columnWidth = 120
    stackgrid.config.columnWidth = 120
  else
    this.innerHTML = 'columnWidth - 320'
    grid.columnWidth = 320
    stackgrid.config.columnWidth = 320
  stackgrid.reset()
  return

# Clear.
button.nine.onclick = ->
  grid.$container.removeChild item for item in grid.$items
  stackgrid.reset()
  return
