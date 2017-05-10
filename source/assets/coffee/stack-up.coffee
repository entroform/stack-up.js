# licensed under the MIT license - http://opensource.org/licenses/MIT
# copyright (C) 2017 Andrew Prasetya
# version: 2017-05-10

class @StackUp

  boundaryHeight : 0
  boundaryWidth  : 0
  containerEl    : undefined
  containerHeight: 0
  containerWidth : 0
  itemEls        : undefined
  items          : [] # format: [index][item, itemHeight, left, top]
  numberOfColumns: 0

  config:
    boundaryEl         : window
    columnWidth        : 320
    containerSelector  : undefined
    gutter             : 18
    isFluid            : false
    itemsSelector      : undefined
    layout             : 'ordinal' # ordinal, optimized
    numberOfColumns    : 3
    resizeDebounceDelay: 350
    moveItem: (item, left, top, callback) ->
      item.style.left = left + 'px'
      item.style.top  = top + 'px'
      callback()
    scaleContainer: (container, width, height, callback) ->
      container.style.height = height + 'px'
      container.style.width  = width + 'px'
      callback()

  constructor: (properties) ->
    @setConfig properties
    this

  setConfig: (config) ->
    if config
      @config[property] = value for property, value of config
    this

  initialize: ->
    window.addEventListener 'resize', @resizeHandler
    @boundaryUpdate()
    # update grid selectors - reset
    @getEls()
    @populateItems()
    # update grid selectors - stacking
    @updateNumberOfColumns()
    @applyLayout()
    @draw()
    this

  boundaryUpdate: ->
    if @config.boundaryEl isnt window
      style = @config.boundaryEl.currentStyle || window.getComputedStyle(@config.boundaryEl)
      horizontalPaddings = parseFloat(style.paddingLeft) + parseFloat(style.paddingRight)
      verticalPaddings   = parseFloat(style.paddingTop) + parseFloat(style.paddingBottom)
      @boundaryHeight    = @config.boundaryEl.offsetHeight - verticalPaddings
      @boundaryWidth     = @config.boundaryEl.offsetWidth - horizontalPaddings
    else
      @boundaryHeight = window.innerHeight
      @boundaryWidth  = window.innerWidth
    this

  resizeDebounceTimeout: undefined
  resizeDebounce: (fn, delay) ->
    clearTimeout @resizeDebounceTimeout
    @resizeDebounceTimeout = window.setTimeout fn, delay
    this

  resizeComplete: =>
    @restack() if @calculateNumberOfColumns() isnt @numberOfColumns and @config.isFluid
    this

  resizeHandler: =>
    @boundaryUpdate()
    @resizeDebounce @resizeComplete, @config.resizeDebounceDelay
    this

  # Update grid selectors. (1) - reset
  # required stack-up.initialize to be called first.
  getEls: ->
    @containerEl = document.querySelector @config.containerSelector
    @itemEls     = document.querySelectorAll "#{@config.containerSelector} > #{@config.itemsSelector}"
    this

  # this only updates @items, it does not update the selectors
  appendItem: (item) ->
    item.style.width = "#{@config.columnWidth}px"
    @items.push [item, item.offsetHeight, 0, 0]
    this

  # populate grid items (2) - reset
  populateItems: ->
    # clear items before populating
    @items = []
    @appendItem item for item, index in @itemEls
    this

  calculateNumberOfColumns: ->
    if @config.isFluid
      numberOfColumns = Math.floor (@boundaryWidth - @config.gutter) / (@config.columnWidth + @config.gutter)
    else
      numberOfColumns = @config.numberOfColumns
    numberOfColumns = @items.length if numberOfColumns > @items.length
    numberOfColumns = 1 if @items.length and numberOfColumns <= 0
    return numberOfColumns

  # update numberOfColumns (3) - stack
  updateNumberOfColumns: ->
    @numberOfColumns = @calculateNumberOfColumns()
    this

  # scale container and move items (5) - stack
  draw: ->
    @containerWidth = (@config.columnWidth + @config.gutter) * @numberOfColumns
    height          = @containerHeight + @config.gutter
    width           = @containerWidth + @config.gutter
    @config.scaleContainer @containerEl, width, height, =>
      callback = ->
      @config.moveItem item[0], item[2], item[3], callback for item, index in @items
    this

  # stack (4)
  # layout updates the containerHeight and updates items
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
    this

  resetLayout: ->
    @containerHeight      = 0
    @layout.columnPointer = 0
    this

  # This should be called when any of the item(s) are being modified, added, or removed
  reset: ->
    @containerWidth  = 0
    @containerHeight = 0
    @items           = []
    @getEls().populateItems().resetLayout().restack()
    this

  append: (item, callback) ->
    itemIndex = @items.length
    @appendItem item
    if @calculateNumberOfColumns() is @numberOfColumns
      @layout[@config.layout].plot itemIndex
      @draw()
    else
      @restack()
    this

  restack: ->
    @updateNumberOfColumns().resetLayout().applyLayout().draw()
    this
