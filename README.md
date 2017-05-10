# stack-up.js

A simple and fast JavaScript plugin to help you create fixed-width, variable-height grid layout.

## Getting started

First, include _stack-up.js_ to your project.

```html
<!-- Example HTML -->
<div id="gridContainer">
  <div class="gridItem">...</div>
  <div class="gridItem">...</div>
  <div class="gridItem">...</div>
</div>

<!-- Scripts -->
<script src="js/stack-up.js"></script>
```

### Minimum CSS requirements

```css
#gridContainer {
  position: relative;
}

.gridItem {
  position: absolute;
}

.gridItem img {
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
    containerSelector: "#gridContainer",
    itemsSelector    : "#gridContainer > .gridItem",
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

Once the grid is initialized; you will need to call the `restack` method if you change any of the configurations.


```javascript

stackup.config.layout = 'optimized';
stackup.restack();
```

The `restack` method will not work properly if you change something that affect the dimensions of the grid item.
You will have to use `reset` instead. (This recalculates the grid stacking from top to bottom.)

```javascript
stackup.config.columnWidth = 220;
stackup.reset();
```

You will also need to use the `reset` method if you add or remove any grid item.

## Append

The `append` method allows you to add a new grid item without re-calculating everything.

```javascript
// Get container element.
var gridContainer = document.getElementById("gridContainer");

// Create a new grid item element.
var gridItem = document.createElement("div");
gridItem.setAttribute("class", "gridItem");
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

Copyright (C) 2017 Andrew Prasetya
