# stackgrid.adem.js

A very simple and highly customizable jQuery plugin for sorting and stacking stuff in a nice and efficient way!
Click here for a demo:
http://heyadem.github.io/stackgrid.adem.js/

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

Make sure all the contents inside the grid-item are fully loaded before initializing stackgrid,
especially if it contain images. This is to make sure stackgrid calculates the right height before plotting it into the grid.

```javascript

// Wrap the initializer inside window on load to
// make sure to wait until all the grid contents are loaded.
var $window = $(window);
$window.on('load', function(){

  // Some stackgrid options!
  $.stackgrid.config = {

    // Your column width!
    column_width: 320,

    // Adjust spacing in between grid-items.
    gutter: 20,

    // If this is set as true, stackgrid will automatically
    // determine the number of columns based on the
    // viewport's width.
    is_fluid: true,

    // Set this as true to sort the grid in an optimal way.
    is_optimized: true,

    // If is_fluid is set as false, it will
    // use this as the default number of columns.
    number_of_columns: 4,

    // Delay in between resize to call the resize complete function.
    resize_delay: 100,

    // You can customize when and how the item is moved!
    // Make sure to use jQuery stop() function if you decide to
    // animate. Where you place the callback function determines
    // when the next operation is called.
    move: function(element, left, top, callback) {
      element.css({
        left: left,
        top: top
      )};
      callback();
    },

    // This function is used to scale the container.
    scale: function(element, height, width, callback) {
      element.css({
        height: height,
        width: width
      });
      callback();
    }

  };

  // You can overwrite config options here,
  // or you can just modify them directly.
  options = {
    column_width: 400
  }

  // Once you're done setting the options,
  // initialize stackgrid!
  // The first two arguments take in the container selector and the item selector.
  $.stackgrid( '#grid-container', '.grid-item', options);

  // Modify config directly:
  $.stackgrid.config.column_width = 500;

  // When you're modify the grid-item dimension, or if you remove a grid-item,
  // make sure to reset it first before re-stacking.
  $.stackgrid.reset()

  // Restack the grid.
  $.stackgrid.restack();

  // You don't need to use reset for other options
  // not involving the dimension of the grid item.
  $.stackgrid.config.is_fluid = false;
  $.stackgrid.restack();

  // You can also append new items into the grid without restacking.
  $item = $("<div class='grid-item'>I'm a new grid item!</div>");
  $.stackgrid.append($item);
  
  // That's it! :)

});


```



