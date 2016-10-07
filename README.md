# stack-up.js

A simple and fast JavaScript plugin to help you create fixed-width, variable-height grid layout.

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

### Minimum CSS requirements

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

Make sure all content inside the container are loaded before initializing stack-up.
This is to make sure stack-up calculates the right height before plotting.

```javascript

// One way to make sure everything is loaded is
// to wrap the initializer inside window onload.
window.onload = function() {

  // Create a stackup object.
  var stackup = new StackUp({
    containerSelector: "#grid-container",
    itemsSelector    : "#grid-container > .grid-item",
    columnWidth      : 240,
  });
  // Initialize stackup.
  stackup.initialize();

};
```

## Config

Customize stack-up to your needs.

```javascript
stackup.setConfig({
  columnWidth        : 320,
  gutter             : 18,
  isFluid            : false,
  layout             : "ordinal", // ordinal, optimized
  numberOfColumns    : 3,
  resizeDebounceDelay: 350
});

// This function allows you to modify how each item is moved or animated.
stackup.config.moveItem: function(item, left, top, callback) {
  item.style.left = left + "px";
  item.style.top  = top + "px";
  // The callback function is required to continue operation.
  callback();
};

// This one allows you to modify how the container scales.
stackup.config.scaleContainer: function(container, width, height, callback) {
  container.style.width  = width + "px";
  container.style.height = height + "px";
  // The callback function is required to continue operation.
  callback();
};
```

## Reset and restack

If you change any of the configurations after the grid is initialized,
you will need to call the `restack` method.

```javascript

stackup.config.layout = 'optimized';
stackup.restack();
```

The `restack` method will not work properly if you change something that affect the dimensions of the grid item.
You will have to use `reset` instead. (This recalculates the grid stacking from top to bottom)

```javascript
stackup.config.columnWidth = 220;
stackup.reset();
```

You will also need to use the `reset` method if you add or remove any grid item.

## Append

The `append` method allows you to add a new grid item without calculating the whole grid.
This saves computation time!

```javascript
// Get container element.
var gridContainer = document.getElementById("grid-container");

// Create a new grid item element.
var gridItem = document.createElement("div");
gridItem.setAttribute("class", "grid-item");
gridItem.innerHTML = "blah blah";

// Append the new grid item element into container element.
gridContainer.appendChild(gridItem);

// Append it to stackup.
stackup.append(gridItem);
```

There is currently no `prepend` method.

That's it!

## License

StackUp is licensed under the MIT license - http://opensource.org/licenses/MIT

Copyright (C) 2016 Andrew Prasetya
