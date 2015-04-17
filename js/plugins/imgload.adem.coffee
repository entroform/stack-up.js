# imgload.adem.js
$.imgload = (url, callback) ->
  img = new Image()
  img.src = url
  info = {
    url: url
    height: img.height
    width: img.width
    ratio: img.width / img.height
  }
  img.onload = ->
    callback info
  return info
