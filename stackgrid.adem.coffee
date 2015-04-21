# stackgrid.adem.js
# adwm.co
# https://github.com/heyadem/stackgrid.adem.js

(($) ->

  $.stackgrid = (container, items, options) ->

    $.extend $.stackgrid.config, options

    $window = $ window
    $document = $ document

    viewport =
      height: $window.height()
      width: $window.width()
      is_resizing: false
      resizing: undefined

    viewport.update = ->
      viewport.height = $window.height()
      viewport.width = $window.width()
      return

    grid =
      $container: undefined
      $items: undefined
      container:
        height: 0
        width: 0
      column:
        index: 0
        stacks:
          ordinal: []
          optimized: []
      # This array contains all the item's object, height, and it's left and right positions
      items: []
      number_of_columns: 0
      plot:
        optimized: {}
        ordinal: {}

    grid.ordinal =
      setup: ->
        i = 0
        grid.column.stacks.ordinal = []
        while i < grid.number_of_columns
          grid.column.stacks.ordinal[i] = 0
          i++
        grid.container.height = 0
        grid.column.index = 0
        return

      plot: (item_index) ->
        # Update left and top value.
        grid.items[item_index][2] = $.stackgrid.config.gutter + ($.stackgrid.config.column_width + $.stackgrid.config.gutter) * grid.column.index
        grid.items[item_index][3] = $.stackgrid.config.gutter + grid.column.stacks.ordinal[grid.column.index]
        # Update grid stack.
        grid.column.stacks.ordinal[grid.column.index] += grid.items[item_index][1] + $.stackgrid.config.gutter
        # Update container height.
        if grid.column.stacks.ordinal[grid.column.index] > grid.container.height
          grid.container.height = grid.column.stacks.ordinal[grid.column.index]
        # Move column index by 1.
        grid.column.index++
        # Reset column index if it exceeded the number of columns.
        if grid.column.index >= grid.number_of_columns
          grid.column.index = 0
        return

      loop: ->
        i = 0
        while i < grid.items.length
          grid.ordinal.plot i
          i++
        return

    grid.optimized =
      setup: ->
        grid.column.stacks.optimized = []
        i = 0
        while i < grid.number_of_columns
          grid.column.stacks.optimized[i] = [i, 0]
          i++
        grid.container.height = 0
        grid.column.index = 0
        return

      plot: (item_index) ->
        grid.items[item_index][2] = $.stackgrid.config.gutter + ($.stackgrid.config.column_width + $.stackgrid.config.gutter) * grid.column.stacks.optimized[0][0]
        grid.items[item_index][3] = $.stackgrid.config.gutter + grid.column.stacks.optimized[0][1]
        grid.column.stacks.optimized[0][1] += grid.items[item_index][1] + $.stackgrid.config.gutter
        if grid.column.stacks.optimized[0][1] > grid.container.height
          grid.container.height = grid.column.stacks.optimized[0][1]
        grid.column.stacks.optimized.sort (a, b) ->
          return a[1] - b[1]
        grid.column.index++
        if grid.column.index >= grid.number_of_columns
          grid.column.index = 0
        return

      loop: ->
        i = 0
        while i < grid.items.length
          grid.optimized.plot i
          i++
        return

    # Grid initialize should only be called once.
    grid.initialize = ->
      $.stackgrid.config.container_selector = container
      $.stackgrid.config.item_selector = items

    grid.setup = ->
      $.stackgrid.reset()
      # Update selectors.
      grid.$container = $ $.stackgrid.config.container_selector
      grid.$items = $ grid.$container.find $.stackgrid.config.item_selector

      # Update grid.items.
      for item, index in grid.$items
        $item = $ item
        $item.width $.stackgrid.config.column_width
        height = $item.outerHeight()
        grid.items[index] = [$item, height, 0, 0]
      return

    grid.container.scale = (callback) ->
      if grid.items.length < grid.number_of_columns
        grid.container.width = ($.stackgrid.config.column_width + $.stackgrid.config.gutter) * grid.items.length
      else
        grid.container.width = ($.stackgrid.config.column_width + $.stackgrid.config.gutter) * grid.number_of_columns
      height = grid.container.height + $.stackgrid.config.gutter
      width = grid.container.width + $.stackgrid.config.gutter
      $.stackgrid.config.scale grid.$container, width, height, callback
      return

    grid.paint = ->
      grid.container.scale ->
        for item, index in grid.items
          callback = ->
          $.stackgrid.config.move item[0], item[2], item[3], callback
      return

    grid.stack = ->
      # Calculate number of columns if it's set as fluid or not.
      if $.stackgrid.config.is_fluid
        grid.number_of_columns = Math.floor (viewport.width - $.stackgrid.config.gutter) / ($.stackgrid.config.column_width + $.stackgrid.config.gutter)
      else
        grid.number_of_columns = $.stackgrid.config.number_of_columns

      if $.stackgrid.config.is_optimized
        grid.optimized.setup()
        grid.optimized.loop()
      else
        grid.ordinal.setup()
        grid.ordinal.loop()

      grid.paint()
      return

    $.stackgrid.reset = ->
      grid.column.stacks.optimized = []
      grid.column.stacks.ordinal = []
      grid.$items = []
      grid.items = []
      return

    $.stackgrid.restack = ->
      grid.setup()
      grid.stack()
      return

    $.stackgrid.append = (item, callback) ->
      $item = $ item
      item_index = grid.items.length
      $item.width $.stackgrid.config.column_width
      height = $item.outerHeight()
      grid.items[item_index] = [$item, height, 0, 0]
      if $.stackgrid.config.is_optimized
        grid.optimized.plot item_index
      else
        grid.ordinal.plot item_index
      grid.container.scale ->
        $.stackgrid.config.move grid.items[item_index][0], grid.items[item_index][2], grid.items[item_index][3], callback
      return

    resize =
      handler: ->
        viewport.update()
        return
      complete: ->
        grid.stack()
        return

    debounce_timeout = undefined
    debounce = (callback, delay) ->
      clearTimeout debounce_timeout
      debounce_timeout = window.setTimeout callback, delay
      return

    $window.on 'resize', ->
      resize.handler()
      debounce resize.complete, $.stackgrid.config.resize_delay
      return

    grid.initialize()
    grid.setup()
    grid.stack()

    # End plugin.
    return

  # Configuration.
  $.stackgrid.config =
    container_selector: undefined
    item_selector: undefined
    column_width: 320
    gutter: 20
    is_fluid: true
    is_optimized: true
    number_of_columns: 4
    resize_delay: 300
    move: (element, left, top, callback) ->
      element.css
        left: left
        top: top
      callback()
      return
    scale: (element, width, height, callback) ->
      element.css
        height: height
        width: width
      callback()
      return

) jQuery
