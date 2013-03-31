
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.UIElement = (function() {
    function UIElement(p5, opts) {
      var _ref, _ref1;

      this.loc = new p5.PVector(opts.x, opts.y);
      if ((0 < (_ref = opts.width) && _ref < p5.width)) {
        this.width = opts.width;
      } else {
        this.width = 10;
      }
      if ((0 < (_ref1 = opts.height) && _ref1 < p5.height)) {
        this.height = opts.height;
      } else {
        this.height = 10;
      }
      this.color = opts.color;
      this.name = opts.name;
    }

    UIElement.prototype.within = function(targetX, targetY) {
      var x1, x2, y1, y2;

      x1 = this.loc.x - this.width / 2;
      x2 = this.loc.x + this.width / 2;
      y1 = this.loc.y - this.height / 2;
      y2 = this.loc.y + this.height / 2;
      return ((x1 < targetX && targetX < x2)) && ((y1 < targetY && targetY < y2));
    };

    UIElement.prototype.display = function() {
      p5.rectMode(p5.CENTER);
      p5.noStroke;
      if (this.within(p5.mouseX, p5.mouseY)) {
        p5.fill(this.color, 255);
      } else {
        p5.fill(this.color, 180);
      }
      return p5.rect(this.loc.x, this.loc.y, this.width, this.height);
    };

    return UIElement;

  })();

  window.UIBang = (function(_super) {
    __extends(UIBang, _super);

    function UIBang(p5, opts) {
      UIBang.__super__.constructor.call(this, p5, opts);
    }

    return UIBang;

  })(UIElement);

  window.UIToggle = (function(_super) {
    __extends(UIToggle, _super);

    function UIToggle(p5, opts) {
      UIToggle.__super__.constructor.call(this, p5, opts);
      this.state = opts.state;
    }

    return UIToggle;

  })(UIElement);
