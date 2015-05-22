# onimgload.adem.js
(->
  this.onimgload = (url, fn) ->
    img = new Image()
    img.src = url
    info =
      url: url
      height: img.height
      width: img.width
      ratio: img.width / img.height
    img.onload = ->
      fn info
    return info
)()
