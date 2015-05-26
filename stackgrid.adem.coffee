# stackgrid.adem.coffee - adwm.co
# Licensed under the MIT license - http://opensource.org/licenses/MIT
# Copyright (C) 2015 Andrew Prasetya

(->

  this.Stackgrid = ->

    viewport =
      height: 0
      width: 0
      is_resizing: false
      resizing: undefined

    (viewport.update = ->
      viewport.height = window.innerHeight
      viewport.width = window.innerWidth
      return
    )()

    grid =
      # container element
      $container: undefined
      $items: undefined
      container_height: 0
      container_width: 0

      pointer: 0

      # [index][item, item_height, left, top]
      items: []
      number_of_columns: 0

    grid.ordinal =
      stack: []
      setup: ->
        i = 0
        grid.ordinal.stack = []
        while i < grid.number_of_columns
          grid.ordinal.stack[i] = 0
          i++
        grid.container_height = 0
        grid.pointer = 0
        return

      plot: (item_index) ->
        # Update left and top value.
        grid.items[item_index][2] = stackgrid.config.gutter + (stackgrid.config.column_width + stackgrid.config.gutter) * grid.pointer
        grid.items[item_index][3] = stackgrid.config.gutter + grid.ordinal.stack[grid.pointer]
        # Update grid stack.
        grid.ordinal.stack[grid.pointer] += grid.items[item_index][1] + stackgrid.config.gutter
        # Update container height.
        if grid.ordinal.stack[grid.pointer] > grid.container_height
          grid.container_height = grid.ordinal.stack[grid.pointer]
        # Move column index by 1.
        grid.pointer++
        # Reset column index if it exceeds the number of columns.
        if grid.pointer >= grid.number_of_columns
          grid.pointer = 0
        return

      loop: ->
        i = 0
        while i < grid.items.length
          grid.ordinal.plot i
          i++
        return

    grid.optimized =
      stack: []
      setup: ->
        grid.optimized.stack = []
        i = 0
        while i < grid.number_of_columns
          grid.optimized.stack[i] = [i, 0]
          i++
        grid.container_height = 0
        grid.pointer = 0
        return

      plot: (item_index) ->
        grid.items[item_index][2] = stackgrid.config.gutter + (stackgrid.config.column_width + stackgrid.config.gutter) * grid.optimized.stack[0][0]
        grid.items[item_index][3] = stackgrid.config.gutter + grid.optimized.stack[0][1]
        grid.optimized.stack[0][1] += grid.items[item_index][1] + stackgrid.config.gutter
        if grid.optimized.stack[0][1] > grid.container_height
          grid.container_height = grid.optimized.stack[0][1]
        grid.optimized.stack.sort (a, b) ->
          return a[1] - b[1]
        grid.pointer++
        if grid.pointer >= grid.number_of_columns
          grid.pointer = 0
        return

      loop: ->
        i = 0
        while i < grid.items.length
          grid.optimized.plot i
          i++
        return

    grid.setup = ->
      stackgrid.reset()

      # Update selectors.
      grid.$container = document.querySelector stackgrid.config.container_selector
      grid.$items = document.querySelectorAll "#{stackgrid.config.container_selector} > #{stackgrid.config.item_selector}"

      # Populate grid items.
      for item, index in grid.$items
        item.style.width = "#{stackgrid.config.column_width}px"
        item_height = item.offsetHeight
        grid.items[index] = [item, item_height, 0, 0]
      return

    grid.scale_container = (callback) ->
      if grid.items.length < grid.number_of_columns
        grid.container_width = (stackgrid.config.column_width + stackgrid.config.gutter) * grid.items.length
      else
        grid.container_width = (stackgrid.config.column_width + stackgrid.config.gutter) * grid.number_of_columns
      height = grid.container_height + stackgrid.config.gutter
      width = grid.container_width + stackgrid.config.gutter
      stackgrid.config.scale grid.$container, width, height, callback
      return

    grid.paint = ->
      grid.scale_container ->
        for item, index in grid.items
          callback = ->
          stackgrid.config.move item[0], item[2], item[3], callback
      return

    grid.stack = ->
      # Calculate number of columns if it's set as fluid or not.
      if stackgrid.config.is_fluid
        grid.number_of_columns = Math.floor (viewport.width - stackgrid.config.gutter) / (stackgrid.config.column_width + stackgrid.config.gutter)
      else
        grid.number_of_columns = stackgrid.config.number_of_columns

      if stackgrid.config.is_optimized
        grid.optimized.setup()
        grid.optimized.loop()
      else
        grid.ordinal.setup()
        grid.ordinal.loop()

      grid.paint()
      return

    resize =
      debounce_timeout: undefined
      complete: ->
        grid.stack()
        return
      debounce: (fn, delay) ->
        clearTimeout resize.debounce_timeout
        resize.debounce_timeout = window.setTimeout fn, delay
        return

    stackgrid =
      config:
        container_selector: undefined
        item_selector: undefined
        column_width: 320
        gutter: 20
        is_fluid: false
        is_optimized: true
        number_of_columns: 3
        resize_debounce_delay: 350

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
      viewport.update()
      stackgrid.config.container_selector = container
      stackgrid.config.item_selector = items

      window.addEventListener 'resize', ->
        viewport.update()
        resize.debounce resize.complete, stackgrid.config.resize_debounce_delay
        return

      grid.setup()
      grid.stack()
      return

    stackgrid.reset = ->
      grid.optimized.stack = []
      grid.ordinal.stack = []
      grid.$items = []
      grid.items = []
      return

    stackgrid.restack = ->
      grid.setup()
      grid.stack()
      return

    stackgrid.append = (item, callback) ->
      item_index = grid.items.length
      item.style.width = "#{stackgrid.config.column_width}px"
      item_height = item.offsetHeight
      grid.items[item_index] = [item, item_height, 0, 0]

      if stackgrid.config.is_optimized
        grid.optimized.plot item_index
      else
        grid.ordinal.plot item_index

      grid.scale_container ->
        stackgrid.config.move grid.items[item_index][0], grid.items[item_index][2], grid.items[item_index][3], callback
      return

    return stackgrid

)()
