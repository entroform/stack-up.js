# stackgrid.adem.js

A very simple and highly customizable jQuery plugin for sorting and stacking stuff in a nice and efficient way!

Click below for a demo:

http://heyadem.github.io/stackgrid/

## Getting started.

First, include stackgrid.adem.js in your project:

```html
<!-- Example Grid HTML -->
<div id="grid-container">
  <div class="grid-item">...</div>
  <div class="grid-item">...</div>
  <div class="grid-item">...</div>
</div>

<!-- Don't forget to include jQuery! -->
<script src="js/jquery.js"></script>
<script src="js/stackgrid.adem.js"></script>
```

Make sure all the contents inside the grif are fully loaded before initializing stackgrid,
especially if it contain any image(s). This is to make sure stackgrid calculates the right height before plotting.


```javascript

// Wrap the initializer inside window on load to
// make sure to wait until all the grid contents are loaded.
var $window = $(window);
$window.on('load', function(){

  // This is all it needs to work!
  // The first two arguments are for the container selector and the item selector.
  $.stackgrid('#grid-container', '.grid-item');

});

```

## Advanced options.

Please refer to the following if you want to further configurate stackgrid.

```javascript

// Begin configurating stackgrid.
// The options listed here are default.
$.stackgrid.config = {

  // Your column width!
  column_width: 320,

  // Adjust spacing in-between grid-items.
  gutter: 20,

  // Set this as true to let stackgrid automatically
  // determine the number of columns based on the
  // viewport's width.
  is_fluid: true,

  // Set this as true to sort the grid in an vertically optimal way.
  is_optimized: true,

  // If is_fluid is false, it will
  // use this as the default number of columns.
  number_of_columns: 4,

  // Timeout delay to call the resize complete function.
  resize_delay: 100,

  // You can customize when and how each item is moved!
  // Make sure to use jQuery stop() function if you decide to
  // animate it.
  // Where you place the callback determines
  // when the next move operation is called.
  move: function(element, left, top, callback) {
    element.css({
      left: left,
      top: top
    )};
    callback();
  },

  // This function is used to scale the container containing
  // the grid items.
  // The callback function starts the move operations.
  scale: function(element, width, height, callback) {
    element.css({
      height: height,
      width: width
    });
    callback();
  }

};

// You can overwrite config options here,
// or you can modify them directly from $.stackgrid.config
options = {
  column_width: 400
}

// Initialize stackgrid!
// The first two arguments are for the container selector and the item selector.
$.stackgrid('#grid-container', '.grid-item', options);

// You can modify config directly:
$.stackgrid.config.column_width = 500;

// When you are modifying the grid-item's dimensions or if you remove a grid-item,
// make sure to call reset before re-stacking.
$.stackgrid.reset();

// Restack the grid.
$.stackgrid.restack();

// You don't need to use reset for other grid configurations that does
// not involve the dimensions of the grid item.
$.stackgrid.config.is_fluid = false;
$.stackgrid.restack();

// You can also append a new item into the grid without restacking.
$item = $("<div class='grid-item'>I'm a new grid item!</div>");
$.stackgrid.append($item);

// That's it! :)

```

Enjoy!

