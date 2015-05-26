# stackgrid.adem.coffee - adwm.co
# Licensed under the MIT license - http://opensource.org/licenses/MIT
# Copyright (C) 2015 Andrew Prasetya

(->

  @Stackgrid = ->

    _viewport = height: 0, width: 0

    (_viewport.update = ->
      @height = window.innerHeight
      @width = window.innerWidth
      return
    )()

    _resize =
      debounceTimeout: undefined
      debounce: (fn, delay) ->
        clearTimeout @debounceTimeout
        @debounceTimeout = window.setTimeout fn, delay
        return
      complete: ->

    _grid =
      $container: undefined
      $items: undefined
      container: height: 0, width: 0
      items: [] # [index][item, itemHeight, left, top]
      columnPointer: 0
      numberOfColumns: 0
      updateSelectors: ->
      updateItems: ->
      updateNumberOfColumns: ->
      scaleContainer: ->
      plot: ->
      stack: ->

    _grid.updateSelectors = ->
      @$container = document.querySelector stackgrid.config.containerSelector
      @$items = document.querySelectorAll "#{stackgrid.config.containerSelector} > #{stackgrid.config.itemSelector}"
      return

    _grid.updateItems = ->
      if @$items.length > 0
        for item, index in @$items
          item.style.width = "#{stackgrid.config.columnWidth}px"
          itemHeight = item.offsetHeight
          @items[index] = [item, itemHeight, 0, 0]
      return

    _grid.updateNumberOfColumns = ->
      if stackgrid.config.isFluid
        @numberOfColumns = Math.floor (_viewport.width - stackgrid.config.gutter) / (stackgrid.config.columnWidth + stackgrid.config.gutter)
      else
        @numberOfColumns = stackgrid.config.numberOfColumns
      @numberOfColumns = @items.length if @numberOfColumns > @items.length
      return

    _grid.scaleContainer = (callback) ->
      if @items.length < @numberOfColumns
        @container.width = (stackgrid.config.columnWidth + stackgrid.config.gutter) * @items.length
      else
        @container.width = (stackgrid.config.columnWidth + stackgrid.config.gutter) * @numberOfColumns
      height = @container.height + stackgrid.config.gutter
      width = @container.width + stackgrid.config.gutter
      stackgrid.config.scale @$container, width, height, callback
      return

    _grid.plot = ->
      @scaleContainer =>
        for item, index in @items
          callback = ->
          stackgrid.config.move item[0], item[2], item[3], callback
      return

    _grid.stack = ->
      @updateNumberOfColumns()
      _grid.container.height = 0
      _grid.columnPointer = 0
      _layout[stackgrid.config.layout].setup()
      _layout[stackgrid.config.layout].loop() if @items.length > 0
      @plot()
      return

    _layout =
      ordinal:
        stack: []
        setup: () ->
          @stack = ([i] = 0 for i in [0.._grid.numberOfColumns - 1])
          return
        plot: (itemIndex) ->
          _grid.items[itemIndex][2] = stackgrid.config.gutter + (stackgrid.config.columnWidth + stackgrid.config.gutter) * _grid.columnPointer
          _grid.items[itemIndex][3] = stackgrid.config.gutter + @stack[_grid.columnPointer]
          @stack[_grid.columnPointer] += _grid.items[itemIndex][1] + stackgrid.config.gutter
          _grid.container.height = @stack[_grid.columnPointer] if @stack[_grid.columnPointer] > _grid.container.height
          _grid.columnPointer++
          _grid.columnPointer = 0 if _grid.columnPointer >= _grid.numberOfColumns
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
          _grid.container.height = @stack[0][1] if @stack[0][1] > _grid.container.height
          @stack.sort ( (a, b) -> return a[1] - b[1] )
          _grid.columnPointer++
          _grid.columnPointer = 0 if _grid.columnPointer >= _grid.numberOfColumns
          return
        loop: ->
          @plot i for i in [0.._grid.items.length - 1]
          return

    _resize.complete = ->
      _grid.stack()
      return

    stackgrid =
      config:
        containerSelector: undefined
        itemSelector: undefined
        columnWidth: 320
        gutter: 20
        isFluid: false
        layout: 'ordinal'
        numberOfColumns: 4
        resizeDebounceDelay: 350

    stackgrid.config.move = (element, left, top, callback) ->
      element.style.left = "#{left}px"
      element.style.top = "#{top}px"
      callback()
      return

    stackgrid.config.scale = (element, width, height, callback) ->
      element.style.height = "#{height}px"
      element.style.width = "#{width}px"
      callback()
      return

    stackgrid.initialize = (container, items) ->
      _viewport.update()
      window.addEventListener 'resize', =>
        _viewport.update()
        _resize.debounce _resize.complete, @config.resizeDebounceDelay
        return
      @config.containerSelector = container
      @config.itemSelector = items
      _grid.updateSelectors()
      _grid.updateItems()
      _grid.stack()
      return

    stackgrid.reset = ->
      _grid.container = width: 0, height: 0
      _grid.items = []
      _grid.updateSelectors()
      _grid.updateItems()
      return

    stackgrid.restack = ->
      _grid.stack()
      return

    return stackgrid

)()
