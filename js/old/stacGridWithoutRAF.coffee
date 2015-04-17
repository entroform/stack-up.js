# stackGrid.js
# author: Andrew Prasetya AKA Adem

(($) ->

  $.fn.stackGrid = ( blocks, options ) ->

    container = this
    $window = $ window

    triggerUpdate = true

    viewport = {
      width:  0
      height: 0
      update: ->
    }

    viewport.update = ->
      viewport.width = $window.width()
      return

    # Default settings.
    settings = $.extend {
      ignore:          null
      columnWidth:     196
      numberOfColumns: 4
      gutter:          16
      isFluid:         0
      isOptimized:     0
      move: (block, left, top, callback) ->
        block.stop().animate {
          left: left
          top: top
        }, callback
      scale: (container, width, height, callback) ->
        container.stop().animate {
          width: width
          height: height
        }
    }, options

    # Grid - Schema
    grid = {
      computedNumberOfColumns: 0
      plot: ->
    }

    grid.properties = {
      columnWidth:     settings.columnWidth
      gutter:          settings.gutter
      numberOfColumns: settings.numberOfColumns
      isFluid:         settings.isFluid
      isOptimized:     settings.isOptimized
      update: ->
    }

    grid.container = {
      self: $ container
      width: 0
      height: 0
      scale: ->
    }

    grid.data = {
      columnWidth:     undefined
      gutter:          undefined
      numberOfColumns: undefined
      isFluid:         undefined
      isOptimized:     undefined
      update: ->
    }

    grid.blocks = {
      self: grid.container.self.find( blocks ).not settings.ignore
      length: 0
      update: ->
    }

    grid.initialize = ->
      grid.container.self = $ container
      grid.blocks.self = grid.container.self.find( blocks ).not settings.ignore
      grid.container.self.css { position: 'relative' }
      grid.blocks.self.css { position: 'absolute' }
      return

    grid.data.update = ->
      # Retrieve and update data from the grid container.
      grid.data.columnWidth     = grid.container.self.data 'stackgrid-column-width'
      grid.data.gutter          = grid.container.self.data 'stackgrid-gutter'
      grid.data.numberOfColumns = grid.container.self.data 'stackgrid-number-of-columns'
      grid.data.isOptimized     = grid.container.self.data 'stackgrid-is-optimized'
      grid.data.isFluid         = grid.container.self.data 'stackgrid-is-fluid'
      return

    grid.properties.update = ->
      # Overwrite settings if the grid container's
      # data attributes are specified.
      grid.properties.columnWidth     = grid.data.columnWidth or settings.columnWidth
      grid.properties.numberOfColumns = grid.data.numberOfColumns or settings.numberOfColumns
      if grid.data.gutter isnt undefined
      then grid.properties.gutter = grid.data.gutter
      else grid.properties.gutter = settings.gutter

      if grid.data.isOptimized isnt undefined
      then grid.properties.isOptimized = grid.data.isOptimized
      else grid.properties.isOptimized = settings.isOptimized

      if grid.data.isFluid isnt undefined
      then grid.properties.isFluid = grid.data.isFluid
      else grid.properties.isFluid = settings.isFluid
      return

    grid.blocks.update = ->
      grid.blocks.self.width = grid.properties.columnWidth
      grid.blocks.length = grid.blocks.self.length
      return

    grid.container.scale = ->
      grid.container.height = 0
      # Determine the container's width.
      if grid.blocks.length < grid.computedNumberOfColumns
        grid.container.width = (grid.properties.columnWidth + grid.properties.gutter) * grid.blocks.length
      else
        grid.container.width = (grid.properties.columnWidth + grid.properties.gutter) * grid.computedNumberOfColumns

      # Determine the container's height value by finding
      # the tallest height + top offset of it's children.
      grid.container.self.children().each ->
        $this = $ this
        offsetTop = $this.outerHeight() + parseInt $this.css 'top'
        grid.container.height = offsetTop if offsetTop > grid.container.height

      # Update the the container's width and height.
      newWidth = grid.container.width + grid.properties.gutter
      newHeight = grid.container.height + grid.properties.gutter

      settings.scale grid.container.self, newWidth, newHeight
      return

    grid.callback = ->
      grid.container.scale()

    grid.plot.ordinal = ( callback ) ->
      BSH = []

      i = 0
      while i < grid.computedNumberOfColumns
        BSH[i] = 0
        i++

      columnCounter = 0
      $.each grid.blocks.self, (index, block) ->
        $block = $ block
        leftOffset = (grid.properties.columnWidth + grid.properties.gutter) * columnCounter + grid.properties.gutter
        topOffset = BSH[columnCounter] + grid.properties.gutter

        settings.move $block, leftOffset, topOffset, grid.callback
        BSH[columnCounter] += $block.outerHeight() + grid.properties.gutter

        if (columnCounter < grid.computedNumberOfColumns - 1)
        then columnCounter++
        else columnCounter = 0

      callback()
      return

    grid.plot.optimized = ( callback ) ->

      # Array containing each block's height in order.
      BH = []
      # Array containing all the previous block's summed heights and location (column index).
      BSH = []
      # Array containing current row's heights and location (column index).
      CBH = []

      # Populate all block's height into an array.
      $.each grid.blocks.self, (index, block) ->
        $block = $ block
        BH[index] = $block.outerHeight()

      i = 0
      while i < grid.computedNumberOfColumns
        BSH[i] = [ i, 0 ]
        CBH[i] = [ i, BH[i] ]
        i++

      columnCounter = 0
      rowCounter = -1

      $.each grid.blocks.self, (index, block) ->
        $block = $ block

        # If this is a start of a new row.
        if index % grid.computedNumberOfColumns is 0
          # Reset column counter and update row counter.
          columnCounter = 0
          rowCounter++

          # If this is not the first row.
          if rowCounter > 0
            # Sort BSH from shortest to tallest.
            BSH.sort (a, b) ->
              if a[1] is b[1]
                0
              else
                (if a[1] > b[1] then 1 else -1)

            # Clear CBH and re-populate it with current row information,
            # then sort it from tallest to shortest.
            CBH = []

            i = 0
            while i < grid.computedNumberOfColumns
              if BH[index + i]?
                CBH[i] = [ i, BH[index + i] ]
              i++

            CBH.sort (a, b) ->
              if a[1] is b[1]
                0
              else
                (if a[1] > b[1] then -1 else 1)

        # End if this is a start of a new row.

        # Find the associated BSH index from matching CBH index of current column.
        PR_INDEX = undefined
        i = 0
        while i < CBH.length
          PR_INDEX = i if CBH[i][0] is columnCounter
          i++

        # Update current item's left and top value.
        leftOffset = (grid.properties.columnWidth + grid.properties.gutter) * BSH[PR_INDEX][0] + grid.properties.gutter
        topOffset = BSH[PR_INDEX][1] + grid.properties.gutter

        settings.move $block, leftOffset, topOffset, grid.callback

        # Update PR's height.
        BSH[PR_INDEX][1] += BH[index] + grid.properties.gutter
        columnCounter++

      callback()
      return

    grid.build = ->
      grid.computedNumberOfColumns = grid.properties.numberOfColumns
      if grid.properties.isFluid
        # Determine the number of columns that can fit inside the viewport.
        numberOfColumns = Math.floor (viewport.width - grid.properties.gutter) / (grid.properties.columnWidth + grid.properties.gutter)
        if grid.properties.numberOfColumns isnt numberOfColumns
          triggerUpdate = true
          grid.computedNumberOfColumns = numberOfColumns

      if triggerUpdate
        triggerUpdate = false
        if grid.properties.isOptimized
          grid.plot.optimized ->
        else
          grid.plot.ordinal ->
      grid.container.scale()
      return

    initialize = ->
      viewport.update()
      grid.initialize()
      grid.data.update()
      grid.properties.update()
      grid.blocks.update()
      triggerUpdate = true
      grid.build()
      return

    resizeHandler = ->
      viewport.update()
      grid.build()
      return

    updateHandler = ->
      grid.data.update()
      grid.properties.update()
      triggerUpdate = true
      grid.build()
      return

    $ ->
      initialize()
      return

    $window.on 'load resize stackgrid', resizeHandler
    $window.on 'load resize stackgrid-initialize', initialize

    grid.container.self.on 'stackgrid-update', updateHandler
    grid.container.self.on 'stackgrid-initialize', initialize

    grid.blocks.self

  return
) jQuery
