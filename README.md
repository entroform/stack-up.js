# stackgrid.adem.js

A very simple and fast javascript stacking plugin.

[Click Here](http://heyadem.github.io/stackgrid/) for a demo.

## Getting started

First, include _stackgrid.adem.js_ in your project.

```html
<!-- Example HTML -->
<div class="grid-container">
  <div class="grid-item">...</div>
  <div class="grid-item">...</div>
  <div class="grid-item">...</div>
</div>

<!-- Scripts -->
<script src="js/stackgrid.adem.js"></script>
```

Make sure all the contents inside are fully loaded before initializing stackgrid.
This is to make sure stackgrid calculates the right height before plotting.

```javascript
var stackgrid = new Stackgrid;

// Config your stackgrid options here.
stackgrid.config.column_width = 240;

// Wrap the initializer inside window on load to
// make sure to wait until everything is loaded.
window.onload = function() {
  stackgrid.initialize('.grid-container', '.grid-item');
};
```

## Advanced

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

// Begin configurating stackgrid.
// The options listed here are default.

stackgrid.config.column_width = 320;
stackgrid.config.gutter = 20;
stackgrid.config.is_fluid = true;
stackgrid.config.layout = 'ordinal';
stackgrid.config.number_of_columns = true;
stackgrid.config.resize_debounce_delay = 400;

// You can customize when and how each item is moved!
// Make sure to use jQuery stop() function if you decide to
// animate it.
// Where you place the callback determines
// when the next move operation is called.

stackgrid.config.move: function(item, left, top, callback) {
  item.style.left = left + "px";
  item.style.top = top + "px";
  callback();
}

// This function is used to scale the container containing
// the grid items.
// The callback function starts the move operations.
stackgrid.config.scale: function(container, width, height, callback) {
  container.style.width = width + "px";
  container.style.height = height + "px";
  callback();
}

// The first two arguments are for the container selector and the item selector.
stackgrid.initialize('.grid-container', '.grid-item');

// You can modify config directly.
stackgrid.config.column_width = 500;

// Append another item to the grid.
var grid_container = document.getElementByClass('grid-container');
var grid_item = document.createElement('div');
grid_item.setAttribute('class', 'grid-item');
grid_container.appendChild(grid_item);

// When you are modifying the grid-item's dimensions or if you remove a grid-item,
// make sure to call reset before re-stacking.
stackgrid.reset();

// Restack the grid.
stackgrid.restack();
```

Enjoy!
