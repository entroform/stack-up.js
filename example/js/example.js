var $button, $buttons, button, buttons, grid, i, j, k, len, len1, stackgrid;

stackgrid = new Stackgrid;

window.onload = function() {
  stackgrid.config.columnWidth = 220;
  stackgrid.config.gutter = 20;
  stackgrid.config.isFluid = false;
  stackgrid.config.layout = 'optimized';
  stackgrid.config.viewport = document.querySelector('#content');
  grid.update();
  stackgrid.config.moveItem = function(item, left, top, callback) {
    return Velocity(item, {
      left: left,
      top: top,
      complete: callback,
      duration: 200,
      queue: false
    });
  };
  stackgrid.config.scaleContainer = function(container, width, height, callback) {
    Velocity(container, 'stop');
    return Velocity(container, {
      height: height,
      width: width,
      complete: callback,
      duration: 200,
      queue: false
    });
  };
  stackgrid.initialize('.grid-container', '.grid-item');
};

grid = {
  $container: void 0,
  $items: void 0,
  columnWidth: 220,
  gutter: 20,
  isFluid: false,
  layout: 'optimized'
};

grid.update = function() {
  var item, j, len, ref;
  this.$container = document.querySelector('.grid-container');
  this.$items = document.querySelectorAll('.grid-item');
  ref = this.$items;
  for (j = 0, len = ref.length; j < len; j++) {
    item = ref[j];
    item.addEventListener('click', this.removeItem);
  }
};

grid.removeItem = function() {
  Velocity(this, {
    scale: 0
  }, 300, (function(_this) {
    return function() {
      grid.$container.removeChild(_this);
      stackgrid.reset();
      return stackgrid.restack();
    };
  })(this));
};

grid.append = function(url) {
  var gridItem;
  gridItem = document.createElement('div');
  gridItem.setAttribute('class', 'grid-item');
  gridItem.innerHTML = "<img src=\"" + url + "\" alt=\"\">";
  onimgload(url, (function(_this) {
    return function() {
      _this.$container.appendChild(gridItem);
      _this.update();
      Velocity(gridItem, {
        scale: 0
      }, 1, function() {
        return stackgrid.append(gridItem);
      });
      return Velocity(gridItem, {
        scale: 1
      }, 200);
    };
  })(this));
};

$buttons = document.getElementsByClassName('control-button');

for (j = 0, len = $buttons.length; j < len; j++) {
  $button = $buttons[j];
  $button.addEventListener('click', (function(event) {
    return event.preventDefault();
  }));
}

buttons = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];

button = {};

for (k = 0, len1 = buttons.length; k < len1; k++) {
  i = buttons[k];
  button[i] = document.querySelector(".control-button.-" + i);
}

button.one.onclick = (function() {
  return grid.append('img/short.jpg');
});

button.two.onclick = (function() {
  return grid.append('img/medium.jpg');
});

button.three.onclick = (function() {
  return grid.append('img/tall.jpg');
});

button.four.onclick = function() {
  if (grid.gutter === 20) {
    this.innerHTML = 'Gutter - 40';
    grid.gutter = 40;
    stackgrid.config.gutter = 40;
  } else if (grid.gutter === 40) {
    this.innerHTML = 'Gutter - 0';
    grid.gutter = 0;
    stackgrid.config.gutter = 0;
  } else {
    this.innerHTML = 'Gutter - 20';
    grid.gutter = 20;
    stackgrid.config.gutter = 20;
  }
  stackgrid.restack();
};

button.five.onclick = function() {
  if (grid.layout === 'ordinal') {
    this.innerHTML = 'Layout - optimized';
    grid.layout = 'optimized';
    stackgrid.config.layout = 'optimized';
  } else {
    this.innerHTML = 'Layout - ordinal';
    grid.layout = 'ordinal';
    stackgrid.config.layout = 'ordinal';
  }
  stackgrid.restack();
};

button.six.onclick = function() {
  if (grid.isFluid) {
    this.innerHTML = 'isFluid - false';
    grid.isFluid = false;
    stackgrid.config.isFluid = false;
  } else {
    this.innerHTML = 'isFluid - true';
    grid.isFluid = true;
    stackgrid.config.isFluid = true;
  }
  stackgrid.restack();
};

button.seven.onclick = function() {
  if (grid.numberOfColumns === 3) {
    this.innerHTML = 'numberOfColumns - 4';
    grid.numberOfColumns = 4;
    stackgrid.config.numberOfColumns = 4;
  } else {
    this.innerHTML = 'numberOfColumns - 3';
    grid.numberOfColumns = 3;
    stackgrid.config.numberOfColumns = 3;
  }
  stackgrid.restack();
};

button.eight.onclick = function() {
  if (grid.columnWidth === 320) {
    this.innerHTML = 'columnWidth - 220';
    grid.columnWidth = 220;
    stackgrid.config.columnWidth = 220;
  } else if (grid.columnWidth === 220) {
    this.innerHTML = 'columnWidth - 120';
    grid.columnWidth = 120;
    stackgrid.config.columnWidth = 120;
  } else {
    this.innerHTML = 'columnWidth - 320';
    grid.columnWidth = 320;
    stackgrid.config.columnWidth = 320;
  }
  stackgrid.reset();
};

button.nine.onclick = function() {
  var item, l, len2, ref;
  ref = grid.$items;
  for (l = 0, len2 = ref.length; l < len2; l++) {
    item = ref[l];
    grid.$container.removeChild(item);
  }
  stackgrid.reset();
};
