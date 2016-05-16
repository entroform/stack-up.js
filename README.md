# stack-up.js

A simple javascript plugin to help you create cascading grid layouts.

## Getting started

First, include _stack-up.js_ in your project.

```html
<!-- Example HTML -->
<div id="grid-container">
  <div class="grid-item">...</div>
  <div class="grid-item">...</div>
  <div class="grid-item">...</div>
</div>

<!-- Scripts -->
<script src="js/stack-up.js"></script>
```

### Minimum CSS requirements.

```css
#grid-container {
  position: relative;
}

.grid-item {
  position: absolute;
}

.grid-item img {
  width: 100%;
}
```

Make sure all content inside are completely loaded before initializing stack-up.
This is to make sure stack-up calculates the right height before plotting.

```javascript
// One way to make sure everything is loaded is
// to wrap the initializer inside window onload.
window.onload = function() {

  // Create a stackup object.
  var stackup = new StackUp({
    containerSelector: '#grid-container',
    itemsSelector: '#grid-container > .grid-item',
    columnWidth: 240,
  });

};
```

## Config

The values shown here are the default values.

```javascript
stackup.config.columnWidth = 320;
stackup.config.gutter = 20;
stackup.config.isFluid = false;

// Currently there are two layout options: "ordinal", and "optimized"
stackup.config.layout = "optimized";
stackup.config.numberOfColumns = 4;
stackup.config.resizeDebounceDelay = 350;

// This method allows you to modify how each item is moved or animated.
stackup.config.moveItem: function(item, left, top, callback) {
  item.style.left = left + "px";
  item.style.top = top + "px";
  callback();
}

// This one allows you to modify how the container scales.
stackup.config.scaleContainer: function(container, width, height, callback) {
  container.style.width = width + "px";
  container.style.height = height + "px";
  // The callback function is important!
  callback();
}
```

## Reset and restack

If you change any of the configurations after the grid is initialized,
you will have to call the _restack_ method.

```javascript
stackup.config.layout = 'ordinal';
stackup.restack();
```

This won't work if you change something that affects the size of the grid item.
for that you will have to use the _reset_ method.

```javascript
stackup.config.columnWidth = 220;
stackup.reset();
```

You will also need to use the reset method if you add or remove a grid item.

## Append

Alternatively you can use the _append_ method to add new grid-item.
This way stackgrid will append it without having to restack the whole grid.

```javascript
// Get container.
var gridContainer = document.getElementById("grid-container");

// Create a new grid-item.
var gridItem = document.createElement("div");
gridItem.setAttribute("class", "grid-item");
gridItem.innerHTML = "blah blah";

// Append the new grid-item into container.
gridContainer.appendChild(gridItem);

// Append it to stackgrid.
stackgrid.append(gridItem);
```

That's it!

## License

StackUp is licensed under the MIT license - http://opensource.org/licenses/MIT

Copyright (C) 2015 Andrew Prasetya
