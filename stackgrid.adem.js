(function() {
  return this.Stackgrid = function() {
    var _grid, _layout, _resize, _viewport, stackgrid;
    _viewport = {
      height: 0,
      width: 0
    };
    (_viewport.update = function() {
      if (stackgrid && stackgrid.config.viewport && stackgrid.config.viewport.nodeType === 1) {
        _viewport.height = stackgrid.config.viewport.offsetHeight;
        return _viewport.width = stackgrid.config.viewport.offsetWidth;
      } else {
        _viewport.height = window.innerHeight;
        return _viewport.width = window.innerWidth;
      }
    })();
    _resize = {
      debounceTimeout: void 0,
      complete: function() {},
      debounce: function(fn, delay) {
        clearTimeout(this.debounceTimeout);
        this.debounceTimeout = window.setTimeout(fn, delay);
      },
      handler: function() {
        _viewport.update();
        _resize.debounce(_resize.complete, stackgrid.config.resizeDebounceDelay);
      }
    };
    _grid = {
      $container: void 0,
      $items: void 0,
      containerHeight: 0,
      containerWidth: 0,
      items: [],
      numberOfColumns: 0,
      updateSelectors: function() {},
      appendItem: function() {},
      populateItems: function() {},
      calculateNumberOfColumns: function() {},
      updateNumberOfColumns: function() {}
    };
    _grid.updateSelectors = function() {
      this.$container = document.querySelector(stackgrid.config.containerSelector);
      this.$items = document.querySelectorAll(stackgrid.config.containerSelector + " > " + stackgrid.config.itemsSelector);
    };
    _grid.appendItem = function(item) {
      item.style.width = stackgrid.config.columnWidth + "px";
      this.items.push([item, item.offsetHeight, 0, 0]);
    };
    _grid.populateItems = function() {
      var index, item, j, len, ref;
      this.items = [];
      ref = this.$items;
      for (index = j = 0, len = ref.length; j < len; index = ++j) {
        item = ref[index];
        this.appendItem(item);
      }
    };
    _grid.calculateNumberOfColumns = function() {
      var numberOfColumns;
      if (stackgrid.config.isFluid) {
        numberOfColumns = Math.floor((_viewport.width - stackgrid.config.gutter) / (stackgrid.config.columnWidth + stackgrid.config.gutter));
      } else {
        numberOfColumns = stackgrid.config.numberOfColumns;
      }
      if (numberOfColumns > this.items.length) {
        numberOfColumns = this.items.length;
      }
      if (this.items.length && numberOfColumns <= 0) {
        numberOfColumns = 1;
      }
      return numberOfColumns;
    };
    _grid.updateNumberOfColumns = function() {
      this.numberOfColumns = this.calculateNumberOfColumns();
    };
    _grid.layout = function() {
      _layout[stackgrid.config.layout].setup();
      if (this.items.length) {
        _layout[stackgrid.config.layout].loop();
      }
    };
    _grid.draw = function() {
      var height, width;
      this.containerWidth = (stackgrid.config.columnWidth + stackgrid.config.gutter) * this.numberOfColumns;
      height = this.containerHeight + stackgrid.config.gutter;
      width = this.containerWidth + stackgrid.config.gutter;
      stackgrid.config.scaleContainer(this.$container, width, height, (function(_this) {
        return function() {
          var callback, index, item, j, len, ref, results;
          callback = function() {};
          ref = _this.items;
          results = [];
          for (index = j = 0, len = ref.length; j < len; index = ++j) {
            item = ref[index];
            results.push(stackgrid.config.moveItem(item[0], item[2], item[3], callback));
          }
          return results;
        };
      })(this));
    };
    _layout = {
      columnPointer: 0,
      ordinal: {
        stack: [],
        setup: function() {
          var i;
          this.stack = (function() {
            var j, ref, ref1, results;
            results = [];
            for (i = j = 0, ref = _grid.numberOfColumns - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
              results.push((ref1 = 0, i = ref1[0], ref1));
            }
            return results;
          })();
        },
        plot: function(itemIndex) {
          _grid.items[itemIndex][2] = stackgrid.config.gutter + (stackgrid.config.columnWidth + stackgrid.config.gutter) * _layout.columnPointer;
          _grid.items[itemIndex][3] = stackgrid.config.gutter + this.stack[_layout.columnPointer];
          this.stack[_layout.columnPointer] += _grid.items[itemIndex][1] + stackgrid.config.gutter;
          if (this.stack[_layout.columnPointer] > _grid.containerHeight) {
            _grid.containerHeight = this.stack[_layout.columnPointer];
          }
          _layout.columnPointer++;
          if (_layout.columnPointer >= _grid.numberOfColumns) {
            _layout.columnPointer = 0;
          }
        },
        loop: function() {
          var i, j, ref;
          for (i = j = 0, ref = _grid.items.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
            this.plot(i);
          }
        }
      },
      optimized: {
        stack: [],
        setup: function() {
          var i;
          this.stack = (function() {
            var j, ref, ref1, results;
            results = [];
            for (i = j = 0, ref = _grid.numberOfColumns - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
              results.push((ref1 = [i, 0], i = ref1[0], ref1));
            }
            return results;
          })();
        },
        plot: function(itemIndex) {
          _grid.items[itemIndex][2] = stackgrid.config.gutter + (stackgrid.config.columnWidth + stackgrid.config.gutter) * this.stack[0][0];
          _grid.items[itemIndex][3] = stackgrid.config.gutter + this.stack[0][1];
          this.stack[0][1] += _grid.items[itemIndex][1] + stackgrid.config.gutter;
          if (this.stack[0][1] > _grid.containerHeight) {
            _grid.containerHeight = this.stack[0][1];
          }
          this.stack.sort((function(a, b) {
            return a[1] - b[1];
          }));
          _layout.columnPointer++;
          if (_layout.columnPointer >= _grid.numberOfColumns) {
            _layout.columnPointer = 0;
          }
        },
        loop: function() {
          var i, j, ref;
          for (i = j = 0, ref = _grid.items.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
            this.plot(i);
          }
        }
      }
    };
    _layout.reset = function() {
      _grid.containerHeight = 0;
      this.columnPointer = 0;
    };
    stackgrid = {
      config: {
        containerSelector: void 0,
        itemsSelector: void 0,
        columnWidth: 320,
        gutter: 20,
        isFluid: false,
        layout: 'ordinal',
        numberOfColumns: 4,
        resizeDebounceDelay: 350
      }
    };
    stackgrid.config.moveItem = function(item, left, top, callback) {
      item.style.left = left + "px";
      item.style.top = top + "px";
      callback();
    };
    stackgrid.config.scaleContainer = function(container, width, height, callback) {
      container.style.height = height + "px";
      container.style.width = width + "px";
      callback();
    };
    _resize.complete = function() {
      if (_grid.calculateNumberOfColumns() !== _grid.numberOfColumns && stackgrid.config.isFluid) {
        stackgrid.restack();
      }
    };
    stackgrid.initialize = function(container, items) {
      window.addEventListener('resize', _resize.handler);
      this.config.containerSelector = container;
      this.config.itemsSelector = items;
      _grid.updateSelectors();
      _grid.populateItems();
      _grid.updateNumberOfColumns();
      _grid.layout();
      _grid.draw();
    };
    stackgrid.reset = function() {
      _grid.container = {
        width: 0,
        height: 0
      };
      _grid.items = [];
      _grid.updateSelectors();
      _grid.populateItems();
      _layout.reset();
      this.restack();
    };
    stackgrid.append = function(item, callback) {
      var itemIndex;
      itemIndex = _grid.items.length;
      _grid.appendItem(item);
      if (_grid.calculateNumberOfColumns() === _grid.numberOfColumns) {
        _layout[stackgrid.config.layout].plot(itemIndex);
        _grid.draw();
      } else {
        this.restack();
      }
    };
    stackgrid.restack = function() {
      _grid.updateNumberOfColumns();
      _layout.reset();
      _grid.layout();
      _grid.draw();
    };
    return stackgrid;
  };
})();
