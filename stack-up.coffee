# Licensed under the MIT license - http://opensource.org/licenses/MIT
# Copyright (C) 2016 Andrew Prasetya

class @StackUp

  containerElement: undefined
  itemElements: undefined
  containerHeight: 0
  containerWidth: 0
  items: [] # format: [index][item, itemHeight, left, top]
  numberOfColumns: 0
  boundary: height: 0, width: 0

  config:
    containerSelector: undefined
    itemsSelector: undefined
    boundary: window
    columnWidth: 320
    gutter: 18
    isFluid: false
    layout: 'ordinal'
    numberOfColumns: 3
    resizeDebounceDelay: 350
    moveItem: (item, left, top, callback) ->
      item.style.left = left + 'px'
      item.style.top = top + 'px'
      callback()
    scaleContainer: (container, width, height, callback) ->
      container.style.height = height + 'px'
      container.style.width = width + 'px'
      callback()

  constructor: (properties) ->
    @config[property] = value for property, value of properties

  initialize: ->
    window.addEventListener 'resize', @resizeHandler
    @boundaryUpdate()
    # Update grid selectors. - reset
    @updateSelectors()
    @populateItems()
    # Update grid selectors. - stacking
    @updateNumberOfColumns()
    @applyLayout()
    @draw()

  boundaryUpdate: ->
    if @config.boundary isnt window
      style = @config.boundary.currentStyle || window.getComputedStyle(@config.boundary)
      horizontalPaddings = parseFloat(style.paddingLeft) + parseFloat(style.paddingRight)
      verticalPaddings = parseFloat(style.paddingTop) + parseFloat(style.paddingBottom)
      @boundary.height = @config.boundary.offsetHeight - verticalPaddings
      @boundary.width = @config.boundary.offsetWidth - horizontalPaddings
    else
      @boundary.height = window.innerHeight
      @boundary.width = window.innerWidth

  resizeDebounceTimeout: undefined
  resizeDebounce: (fn, delay) ->
    clearTimeout @resizeDebounceTimeout
    @resizeDebounceTimeout = window.setTimeout fn, delay

  resizeComplete: =>
    @restack() if @calculateNumberOfColumns() isnt @numberOfColumns and @config.isFluid

  resizeHandler: =>
    @boundaryUpdate()
    @resizeDebounce @resizeComplete, @config.resizeDebounceDelay

  # Update grid selectors. (1) - reset
  # Required stackgrid.initialize to be called first.
  updateSelectors: ->
    @containerElement = document.querySelector @config.containerSelector
    @itemElements = document.querySelectorAll "#{@config.containerSelector} > #{@config.itemsSelector}"

  # This only updates @items, it does not update the selectors.
  appendItem: (item) ->
    item.style.width = "#{@config.columnWidth}px"
    @items.push [item, item.offsetHeight, 0, 0]

  # Populate grid items. (2) - reset
  populateItems: ->
    # Clear items before populating.
    @items = []
    @appendItem item for item, index in @itemElements

  calculateNumberOfColumns: ->
    if @config.isFluid
      numberOfColumns = Math.floor (@boundary.width - @config.gutter) / (@config.columnWidth + @config.gutter)
    else
      numberOfColumns = @config.numberOfColumns
    numberOfColumns = @items.length if numberOfColumns > @items.length
    numberOfColumns = 1 if @items.length and numberOfColumns <= 0
    return numberOfColumns

  # Update _grid.numberOfColumns. (3) - stack
  updateNumberOfColumns: ->
    @numberOfColumns = @calculateNumberOfColumns()

  # scale container and move items. (5) - stack
  draw: ->
    @containerWidth = (@config.columnWidth + @config.gutter) * @numberOfColumns
    height = @containerHeight + @config.gutter
    width = @containerWidth + @config.gutter
    @config.scaleContainer @containerElement, width, height, =>
      callback = ->
      @config.moveItem item[0], item[2], item[3], callback for item, index in @items

  # Stack (4)
  # Layout updates the _grid.containerHeight and updates _grid.items.
  layout:
    columnPointer: 0
    ordinal:
      stack: []
      setup: ->
        @stack = ([i] = 0 for i in [0..@context.numberOfColumns - 1])
      plot: (itemIndex) ->
        c = @context
        c.items[itemIndex][2] = c.config.gutter + (c.config.columnWidth + c.config.gutter) * c.layout.columnPointer
        c.items[itemIndex][3] = c.config.gutter + @stack[c.layout.columnPointer]
        @stack[c.layout.columnPointer] += c.items[itemIndex][1] + c.config.gutter
        c.containerHeight = @stack[c.layout.columnPointer] if @stack[c.layout.columnPointer] > c.containerHeight
        c.layout.columnPointer++
        c.layout.columnPointer = 0 if c.layout.columnPointer >= c.numberOfColumns

      loop: ->
        @plot i for i in [0..@context.items.length - 1]
    optimized:
      stack: []
      setup: ->
        @stack = ([i] = [i, 0] for i in [0..@context.numberOfColumns - 1])
      plot: (itemIndex) ->
        c = @context
        c.items[itemIndex][2] = c.config.gutter + (c.config.columnWidth + c.config.gutter) * @stack[0][0]
        c.items[itemIndex][3] = c.config.gutter + @stack[0][1]
        @stack[0][1] += c.items[itemIndex][1] + c.config.gutter
        c.containerHeight = @stack[0][1] if @stack[0][1] > c.containerHeight
        @stack.sort ( (a, b) -> return a[1] - b[1] )
        c.layout.columnPointer++
        c.layout.columnPointer = 0 if c.layout.columnPointer >= c.numberOfColumns
      loop: ->
        @plot i for i in [0..@context.items.length - 1]

  applyLayout: ->
    @layout[@config.layout].context = this
    @layout[@config.layout].setup()
    @layout[@config.layout].loop() if @items.length

  resetLayout: ->
    @containerHeight = 0
    @layout.columnPointer = 0

  # This should be called when any item are being modified, added, or removed.
  reset: ->
    @containerWidth = 0
    @containerHeight = 0
    @items = []
    @updateSelectors()
    @populateItems()
    @resetLayout()
    @restack()
    return

  append: (item, callback) ->
    itemIndex = @items.length
    @appendItem item
    if @calculateNumberOfColumns() is @numberOfColumns
      @layoutType[stackgrid.config.layout].plot itemIndex
      @draw()
    else
      @restack()

  restack: ->
    @updateNumberOfColumns()
    @resetLayout()
    @applyLayout()
    @draw()
