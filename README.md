# stackgrid.adem.js

A very simple and highly customizable jQuery plugin for sorting and stacking stuff in a nice way!

Click below for a demo:

http://heyadem.github.io/stackgrid/

## Getting started.

First, include stackgrid.adem.js in your project.

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

Make sure all the contents inside are fully loaded before initializing stackgrid.
This is to ensure stackgrid calculates the right height before plotting.


```javascript
// Create a stackgrid object.
var stackgrid = new $.stackgrid;
var options = {
  column_width: 320
};

// Wrap the initializer inside window on load to
// make sure to wait until all the grid contents are loaded.
var $window = $(window);
$window.on('load', function(){

  // Initialize stackgrid!
  // The first two arguments are for the container selector and the item selector.
  stackgrid.initialize('#grid-container', '.grid-item', options);

});
```

## Appending.

Stackgrid allows you to append a new grid item without
having to replot the whole grid.

```javascript
// Create new grid-item.
item = $("<div class=\"grid-item\"> I'm a new grid item. </div>");
// Append it to the grid-container.
item.appendTo("#grid-container");
// *** If the new content has image(s), make sure it's loaded first before appending!
// Append to stackgrid!
stackgrid.append(item);
```

## Re-stacking.

```javascript
// Restack the grid to apply your config changes.
stackgrid.config.is_fluid = false;
stackgrid.restack();

// Certain changes require you to reset the grid.
// These are changes that affect the dimensions of the grid-item or
// if you remove any of the items.
stackgrid.config.column_width = 400;
stackgrid.reset();
stackgrid.restack();
```

## Config.

```javascript
// The values shown here are the default ones.
stackgrid.config = {

  // Your column width.
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
  resize_delay: 300,

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
  // the grid-items.
  // The callback function starts the move operations.
  scale: function(element, width, height, callback) {
    element.css({
      height: height,
      width: width
    });
    callback();
  }
};
```

Enjoy!
