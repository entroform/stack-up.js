# stackgrid.adem.js
# adwm.co
# https://github.com/heyadem/stackgrid.adem.js

(($) ->

  $.stackgrid = ->

    # Grid information.
    grid:
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

    # Main configuration.
    config:
      container_selector: undefined
      item_selector: undefined
      column_width: 320
      gutter: 20
      is_fluid: true
      is_optimized: true
      number_of_columns: 4
      resize_delay: 100

      move: (element, left, top, callback) ->
        element.css
          left: left
          top: top
        callback()
        return

      scale: (element, height, width, callback) ->
        element.css
          height: height
          width: width
        callback()
        return

    initialize: (container, items, options) ->
      self = this

      $.extend self.config, options

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

      self.grid.ordinal =
        setup: ->
          i = 0
          self.grid.column.stacks.ordinal = []
          while i < self.grid.number_of_columns
            self.grid.column.stacks.ordinal[i] = 0
            i++
          self.grid.container.height = 0
          self.grid.column.index = 0
          return

        plot: (item_index) ->
          # Update left and top value.
          self.grid.items[item_index][2] = self.config.gutter + (self.config.column_width + self.config.gutter) * self.grid.column.index
          self.grid.items[item_index][3] = self.config.gutter + self.grid.column.stacks.ordinal[self.grid.column.index]
          # Update grid stack.
          self.grid.column.stacks.ordinal[self.grid.column.index] += self.grid.items[item_index][1] + self.config.gutter
          # Update container height.
          if self.grid.column.stacks.ordinal[self.grid.column.index] > self.grid.container.height
            self.grid.container.height = self.grid.column.stacks.ordinal[self.grid.column.index]
          # Move column index by 1.
          self.grid.column.index++
          # Reset column index if it exceeded the number of columns.
          if self.grid.column.index >= self.grid.number_of_columns
            self.grid.column.index = 0
          return

        loop: ->
          i = 0
          while i < self.grid.items.length
            self.grid.ordinal.plot i
            i++
          return

      self.grid.optimized =
        setup: ->
          self.grid.column.stacks.optimized = []
          i = 0
          while i < self.grid.number_of_columns
            self.grid.column.stacks.optimized[i] = [i, 0]
            i++
          self.grid.container.height = 0
          self.grid.column.index = 0
          return

        plot: (item_index) ->
          self.grid.items[item_index][2] = self.config.gutter + (self.config.column_width + self.config.gutter) * self.grid.column.stacks.optimized[0][0]
          self.grid.items[item_index][3] = self.config.gutter + self.grid.column.stacks.optimized[0][1]
          self.grid.column.stacks.optimized[0][1] += self.grid.items[item_index][1] + self.config.gutter
          if self.grid.column.stacks.optimized[0][1] > self.grid.container.height
            self.grid.container.height = self.grid.column.stacks.optimized[0][1]
          self.grid.column.stacks.optimized.sort (a, b) ->
            return a[1] - b[1]
          self.grid.column.index++
          if self.grid.column.index >= self.grid.number_of_columns
            self.grid.column.index = 0
          return

        loop: ->
          i = 0
          while i < self.grid.items.length
            self.grid.optimized.plot i
            i++
          return

      # Grid initialize should only be called once.
      self.grid.initialize = ->
        self.config.container_selector = container
        self.config.item_selector = items
        return

      self.grid.setup = ->
        self.reset()
        # Update selectors.
        self.grid.$container = $ self.config.container_selector
        self.grid.$items = $ self.grid.$container.find self.config.item_selector

        # Update grid.items.
        for item, index in self.grid.$items
          $item = $ item
          $item.width self.config.column_width
          height = $item.outerHeight()
          self.grid.items[index] = [$item, height, 0, 0]
        return

      self.grid.container.scale = (callback) ->
        if self.grid.items.length < self.grid.number_of_columns
          self.grid.container.width = (self.config.column_width + self.config.gutter) * self.grid.items.length
        else
          self.grid.container.width = (self.config.column_width + self.config.gutter) * self.grid.number_of_columns
        height = self.grid.container.height + self.config.gutter
        width = self.grid.container.width + self.config.gutter
        self.config.scale self.grid.$container, height, width, callback
        return

      self.grid.paint = ->
        self.grid.container.scale ->
          for item, index in self.grid.items
            callback = ->
            self.config.move item[0], item[2], item[3], callback
        return

      self.grid.stack = ->
        # Calculate number of columns if it's set as fluid or not.
        if self.config.is_fluid
          self.grid.number_of_columns = Math.floor (viewport.width - self.config.gutter) / (self.config.column_width + self.config.gutter)
        else
          self.grid.number_of_columns = self.config.number_of_columns

        if self.config.is_optimized
          self.grid.optimized.setup()
          self.grid.optimized.loop()
        else
          self.grid.ordinal.setup()
          self.grid.ordinal.loop()

        self.grid.paint()
        return

      resize =
        handler: ->
          viewport.update()
          return
        complete: ->
          self.grid.stack()
          return

      debounce_timeout = undefined
      debounce = (callback, delay) ->
        clearTimeout debounce_timeout
        debounce_timeout = window.setTimeout callback, delay
        return

      $window.on 'resize', ->
        resize.handler()
        debounce resize.complete, self.config.resize_delay
        return

      self.grid.initialize()
      self.grid.setup()
      self.grid.stack()

      # End plugin.
      return

    reset: ->
      self = this
      self.grid.column.stacks.optimized = []
      self.grid.column.stacks.ordinal = []
      self.grid.$items = []
      self.grid.items = []
      return

    restack: ->
      self = this
      self.grid.setup()
      self.grid.stack()
      return

    append: (item, callback) ->
      self = this
      $item = $ item
      item_index = self.grid.items.length
      $item.width self.config.column_width
      height = $item.outerHeight()
      self.grid.items[item_index] = [$item, height, 0, 0]
      if self.config.is_optimized
        self.grid.optimized.plot item_index
      else
        self.grid.ordinal.plot item_index
      self.grid.container.scale ->
        self.config.move self.grid.items[item_index][0], self.grid.items[item_index][2], self.grid.items[item_index][3], callback
      return

) jQuery
