# stackgrid.adem.coffee - adwm.co
# Licensed under the MIT license - http://opensource.org/licenses/MIT
# Copyright (C) 2015 Andrew Prasetya

(->

  @Stackgrid = ->

    _viewport = height: 0, width: 0
    ( _viewport.update = ->
      if stackgrid&&stackgrid.config.viewport && stackgrid.config.viewport.nodeType == 1
        
        style = stackgrid.config.viewport.currentStyle || window.getComputedStyle(stackgrid.config.viewport);
        paddingHorizontal = parseFloat(style.paddingLeft) + parseFloat(style.paddingRight);
        paddingVertical = parseFloat(style.paddingTop) + parseFloat(style.paddingBottom);

        _viewport.height = stackgrid.config.viewport.offsetHeight-paddingVertical;
        _viewport.width = stackgrid.config.viewport.offsetWidth-paddingHorizontal;

      else
        _viewport.height = window.innerHeight
        _viewport.width = window.innerWidth
      #return;
    )()

    _resize =
      debounceTimeout: undefined
      complete: ->
      debounce: (fn, delay) ->
        clearTimeout @debounceTimeout
        @debounceTimeout = window.setTimeout fn, delay
        return
      handler: ->
        _viewport.update()
        _resize.debounce _resize.complete, stackgrid.config.resizeDebounceDelay
        return

    _grid =
      $container: undefined
      $items: undefined
      containerHeight: 0
      containerWidth: 0
      items: [] # [index][item, itemHeight, left, top]
      numberOfColumns: 0
      updateSelectors: ->
      appendItem: ->
      populateItems: ->
      calculateNumberOfColumns: ->
      updateNumberOfColumns: ->

    # Update grid selectors. (1) - reset
    # Required stackgrid.initialize to be called first.
    _grid.updateSelectors = ->
      @$container = document.querySelector stackgrid.config.containerSelector
      @$items = document.querySelectorAll "#{stackgrid.config.containerSelector} > #{stackgrid.config.itemsSelector}"
      return

    # This only updates @items, it does not update the selectors.
    _grid.appendItem = (item) ->
      item.style.width = "#{stackgrid.config.columnWidth}px"
      @items.push [item, item.offsetHeight, 0, 0]
      return

    # Populate grid items. (2) - reset
    _grid.populateItems = ->
      # Clear items before populating.
      @items = []
      @appendItem item for item, index in @$items
      return

    _grid.calculateNumberOfColumns = ->
      if stackgrid.config.isFluid
        numberOfColumns = Math.floor (_viewport.width - stackgrid.config.gutter) / (stackgrid.config.columnWidth + stackgrid.config.gutter)
      else
        numberOfColumns = stackgrid.config.numberOfColumns
      numberOfColumns = @items.length if numberOfColumns > @items.length
      numberOfColumns = 1 if @items.length and numberOfColumns <= 0
      return numberOfColumns

    # Update _grid.numberOfColumns. (3) - stack
    _grid.updateNumberOfColumns = ->
      @numberOfColumns = @calculateNumberOfColumns()
      return

    _grid.layout = ->
      _layout[stackgrid.config.layout].setup()
      _layout[stackgrid.config.layout].loop() if @items.length
      return

    # scale container and move items. (5) - stack
    _grid.draw = ->
      @containerWidth = (stackgrid.config.columnWidth + stackgrid.config.gutter) * @numberOfColumns
      height = @containerHeight + stackgrid.config.gutter
      width = @containerWidth + stackgrid.config.gutter
      stackgrid.config.scaleContainer @$container, width, height, =>
        callback = ->
        stackgrid.config.moveItem item[0], item[2], item[3], callback for item, index in @items
      return

    # Stack (4)
    # Layout updates the _grid.containerHeight and updates _grid.items.
    _layout =
      columnPointer: 0
      ordinal:
        stack: []
        setup: () ->
          @stack = ([i] = 0 for i in [0.._grid.numberOfColumns - 1])
          return
        plot: (itemIndex) ->
          _grid.items[itemIndex][2] = stackgrid.config.gutter + (stackgrid.config.columnWidth + stackgrid.config.gutter) * _layout.columnPointer
          _grid.items[itemIndex][3] = stackgrid.config.gutter + @stack[_layout.columnPointer]
          @stack[_layout.columnPointer] += _grid.items[itemIndex][1] + stackgrid.config.gutter
          _grid.containerHeight = @stack[_layout.columnPointer] if @stack[_layout.columnPointer] > _grid.containerHeight
          _layout.columnPointer++
          _layout.columnPointer = 0 if _layout.columnPointer >= _grid.numberOfColumns
          return
        loop: ->
          @plot i for i in [0.._grid.items.length - 1]
          return
      optimized:
        stack: []
        setup: ->
          @stack = ([i] = [i, 0] for i in [0.._grid.numberOfColumns - 1])
          return
        plot: (itemIndex) ->
          _grid.items[itemIndex][2] = stackgrid.config.gutter + (stackgrid.config.columnWidth + stackgrid.config.gutter) * @stack[0][0]
          _grid.items[itemIndex][3] = stackgrid.config.gutter + @stack[0][1]
          @stack[0][1] += _grid.items[itemIndex][1] + stackgrid.config.gutter
          _grid.containerHeight = @stack[0][1] if @stack[0][1] > _grid.containerHeight
          @stack.sort ( (a, b) -> return a[1] - b[1] )
          _layout.columnPointer++
          _layout.columnPointer = 0 if _layout.columnPointer >= _grid.numberOfColumns
          return
        loop: ->
          @plot i for i in [0.._grid.items.length - 1]
          return
    _layout.reset = ->
      _grid.containerHeight = 0
      @columnPointer = 0
      return

    stackgrid =
      config:
        containerSelector: undefined
        itemsSelector: undefined
        columnWidth: 320
        gutter: 20
        isFluid: false
        layout: 'ordinal'
        numberOfColumns: 4
        resizeDebounceDelay: 350

    stackgrid.config.moveItem = (item, left, top, callback) ->
      item.style.left = "#{left}px"
      item.style.top = "#{top}px"
      callback()
      return

    stackgrid.config.scaleContainer = (container, width, height, callback) ->
      container.style.height = "#{height}px"
      container.style.width = "#{width}px"
      callback()
      return

    _resize.complete = ->
      stackgrid.restack() if _grid.calculateNumberOfColumns() isnt _grid.numberOfColumns and stackgrid.config.isFluid
      return

    # This should only be called once.
    stackgrid.initialize = (container, items) ->
      window.addEventListener 'resize', _resize.handler
      # Update config selectors.
      @config.containerSelector = container
      @config.itemsSelector = items
      # Update grid selectors. - reset
      _grid.updateSelectors()
      _grid.populateItems()
      # Update grid selectors. - stacking
      _grid.updateNumberOfColumns()
      _grid.layout()
      _grid.draw()
      return

    # This should be called when any of the items are modified, added, or removed.
    stackgrid.reset = ->
      _grid.container = width: 0, height: 0
      _grid.items = []
      _grid.updateSelectors()
      _grid.populateItems()
      _layout.reset()
      @restack()
      return

    stackgrid.append = (item, callback) ->
      itemIndex = _grid.items.length
      _grid.appendItem item
      if _grid.calculateNumberOfColumns() is _grid.numberOfColumns
        _layout[stackgrid.config.layout].plot itemIndex
        _grid.draw()
      else
        @restack()
      return

    stackgrid.restack = ->
      _grid.updateNumberOfColumns()
      _layout.reset()
      _grid.layout()
      _grid.draw()
      return

    return stackgrid

)()
