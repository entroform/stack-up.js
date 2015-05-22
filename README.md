# stackgrid.adem.js

A very simple stacking javascript plugin.

Click below for a demo:

http://heyadem.github.io/stackgrid/

## Getting started.

First, include stackgrid.adem.js in your project.

```html
<!-- Example Grid HTML -->
<div class="grid-container">
  <div class="grid-item">...</div>
  <div class="grid-item">...</div>
  <div class="grid-item">...</div>
</div>

<script src="js/stackgrid.adem.js"></script>
```

Make sure all the contents inside the grid are fully loaded before initializing stackgrid,
especially if it contain any image(s).
This is to make sure stackgrid calculates the right height before plotting.


```javascript
// Create a stackgrid object.
var stackgrid = new $.stackgrid;
var options = {
  column_width: 320
};

// Wrap the initializer inside window on load to
// make sure to wait until all the grid contents are loaded.
window.onload = function(){

  // This is all it needs to work!
  stackgrid = new Stackgrid;
  stackgrid.config.column_width = 240;
  stackgrid.initialize('.grid-container', '.grid-item');

};
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

// Begin configurating stackgrid.
// The options listed here are default.

stackgrid.config.column_width = 320;
stackgrid.config.gutter = 20;
stackgrid.config.is_fluid = true;
stackgrid.config.is_optimized = true;
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

// You can modify config directly:
stackgrid.config.column_width = 500;

// When you are modifying the grid-item's dimensions or if you remove a grid-item,
// make sure to call reset before re-stacking.
stackgrid.reset();

// Restack the grid.
stackgrid.restack();

// You don't need to use reset for other grid configurations that does
// not involve the dimensions of the grid item.
stackgrid.config.is_fluid = false;
stackgrid.restack();

// You can also append a new item into the grid without restacking.
var grid_container = document.getElementByClass('grid-container');
var grid_item = document.createElement('div');
grid_item.setAttribute('class', 'grid-item');
grid_container.appendChild(grid_item);
stackgrid.append(grid_item);

// That's it! :)

```


Enjoy!
