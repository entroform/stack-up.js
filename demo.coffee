# document.addEventListener 'DOMContentLoaded' is buggy on safari..
window.onload = ->

  stackup = new StackUp
    columnWidth       : 220
    containerSelector : '.grid-container'
    gutter            : 18
    isFluid           : true
    itemsSelector     : '.grid-item'
    layout            : 'optimized'

  stackup.initialize()
