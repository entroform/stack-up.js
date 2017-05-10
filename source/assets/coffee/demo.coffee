# document.addEventListener 'DOMContentLoaded' is buggy on safari..
window.onload = ->

  boundaryEl = document.querySelector '.boundary'

  stackup = new StackUp
    boundaryEl        : boundaryEl
    columnWidth       : 240
    containerSelector : '.gridContainer'
    gutter            : 18
    isFluid           : true
    itemsSelector     : '.gridItem'
    layout            : 'optimized'

  stackup.initialize()
