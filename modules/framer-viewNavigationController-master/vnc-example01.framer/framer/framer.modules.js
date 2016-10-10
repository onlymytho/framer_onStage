require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"ViewNavigationController":[function(require,module,exports){
var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

exports.ViewNavigationController = (function(superClass) {
  var ANIMATION_OPTIONS, BACKBUTTON_VIEW_NAME, BACK_BUTTON_FRAME, DEBUG_MODE, DIR, INITIAL_VIEW_NAME, PUSH;

  extend(ViewNavigationController, superClass);

  INITIAL_VIEW_NAME = "initialView";

  BACKBUTTON_VIEW_NAME = "vnc-backButton";

  ANIMATION_OPTIONS = {
    time: 0.3,
    curve: "ease-in-out"
  };

  BACK_BUTTON_FRAME = {
    x: 0,
    y: 40,
    width: 88,
    height: 88
  };

  PUSH = {
    UP: "pushUp",
    DOWN: "pushDown",
    LEFT: "pushLeft",
    RIGHT: "pushRight",
    CENTER: "pushCenter"
  };

  DIR = {
    UP: "up",
    DOWN: "down",
    LEFT: "left",
    RIGHT: "right"
  };

  DEBUG_MODE = false;

  function ViewNavigationController(options) {
    var base, base1, base2, base3;
    this.options = options != null ? options : {};
    this.views = this.history = this.initialView = this.currentView = this.previousView = this.animationOptions = this.initialViewName = null;
    if ((base = this.options).width == null) {
      base.width = Screen.width;
    }
    if ((base1 = this.options).height == null) {
      base1.height = Screen.height;
    }
    if ((base2 = this.options).clip == null) {
      base2.clip = true;
    }
    if ((base3 = this.options).backgroundColor == null) {
      base3.backgroundColor = "#999";
    }
    ViewNavigationController.__super__.constructor.call(this, this.options);
    this.views = [];
    this.history = [];
    this.animationOptions = this.options.animationOptions || ANIMATION_OPTIONS;
    this.initialViewName = this.options.initialViewName || INITIAL_VIEW_NAME;
    this.backButtonFrame = this.options.backButtonFrame || BACK_BUTTON_FRAME;
    this.debugMode = this.options.debugMode != null ? this.options.debugMode : DEBUG_MODE;
    this.on("change:subLayers", function(changeList) {
      return Utils.delay(0, (function(_this) {
        return function() {
          var i, len, ref, results, subLayer;
          ref = changeList.added;
          results = [];
          for (i = 0, len = ref.length; i < len; i++) {
            subLayer = ref[i];
            results.push(_this.addView(subLayer, true));
          }
          return results;
        };
      })(this));
    });
  }

  ViewNavigationController.prototype.addView = function(view, viaInternalChangeEvent) {
    var obj, vncHeight, vncWidth;
    vncWidth = this.options.width;
    vncHeight = this.options.height;
    view.states.add((
      obj = {},
      obj["" + PUSH.UP] = {
        x: 0,
        y: -vncHeight
      },
      obj["" + PUSH.LEFT] = {
        x: -vncWidth,
        y: 0
      },
      obj["" + PUSH.CENTER] = {
        x: 0,
        y: 0
      },
      obj["" + PUSH.RIGHT] = {
        x: vncWidth,
        y: 0
      },
      obj["" + PUSH.DOWN] = {
        x: 0,
        y: vncHeight
      },
      obj
    ));
    view.states.animationOptions = this.animationOptions;
    if (view.name === this.initialViewName) {
      this.initialView = view;
      this.currentView = view;
      view.states.switchInstant(PUSH.CENTER);
      this.history.push(view);
    } else {
      view.states.switchInstant(PUSH.RIGHT);
    }
    if (!(view.superLayer === this || viaInternalChangeEvent)) {
      view.superLayer = this;
    }
    if (view.name !== this.initialViewName) {
      this._applyBackButton(view);
    }
    return this.views.push(view);
  };

  ViewNavigationController.prototype.transition = function(view, direction, switchInstant, preventHistory) {
    if (direction == null) {
      direction = DIR.RIGHT;
    }
    if (switchInstant == null) {
      switchInstant = false;
    }
    if (preventHistory == null) {
      preventHistory = false;
    }
    if (view === this.currentView) {
      return false;
    }
    if (direction === DIR.RIGHT) {
      view.states.switchInstant(PUSH.RIGHT);
      this.currentView.states["switch"](PUSH.LEFT);
    } else if (direction === DIR.DOWN) {
      view.states.switchInstant(PUSH.DOWN);
      this.currentView.states["switch"](PUSH.UP);
    } else if (direction === DIR.LEFT) {
      view.states.switchInstant(PUSH.LEFT);
      this.currentView.states["switch"](PUSH.RIGHT);
    } else if (direction === DIR.UP) {
      view.states.switchInstant(PUSH.UP);
      this.currentView.states["switch"](PUSH.DOWN);
    } else {
      view.states.switchInstant(PUSH.CENTER);
      this.currentView.states.switchInstant(PUSH.LEFT);
    }
    view.states["switch"](PUSH.CENTER);
    this.previousView = this.currentView;
    this.previousView.custom = {
      lastTransition: direction
    };
    this.currentView = view;
    if (preventHistory === false) {
      this.history.push(this.previousView);
    }
    return this.emit("change:view");
  };

  ViewNavigationController.prototype.removeBackButton = function(view) {
    return Utils.delay(0, (function(_this) {
      return function() {
        return view.subLayersByName(BACKBUTTON_VIEW_NAME)[0].visible = false;
      };
    })(this));
  };

  ViewNavigationController.prototype.back = function() {
    var direction, lastTransition, lastView, oppositeTransition, preventHistory, switchInstant;
    lastView = this._getLastHistoryItem();
    lastTransition = lastView.custom.lastTransition;
    oppositeTransition = this._getOppositeDirection(lastTransition);
    this.transition(lastView, direction = oppositeTransition, switchInstant = false, preventHistory = true);
    return this.history.pop();
  };

  ViewNavigationController.prototype._getLastHistoryItem = function() {
    return this.history[this.history.length - 1];
  };

  ViewNavigationController.prototype._applyBackButton = function(view, frame) {
    if (frame == null) {
      frame = this.backButtonFrame;
    }
    return Utils.delay(0, (function(_this) {
      return function() {
        var backButton;
        if (view.backButton !== false) {
          backButton = new Layer({
            name: BACKBUTTON_VIEW_NAME,
            width: 80,
            height: 80,
            superLayer: view
          });
          if (_this.debugMode === false) {
            backButton.backgroundColor = "transparent";
          }
          backButton.frame = frame;
          return backButton.on(Events.Click, function() {
            return _this.back();
          });
        }
      };
    })(this));
  };

  ViewNavigationController.prototype._getOppositeDirection = function(initialDirection) {
    if (initialDirection === DIR.UP) {
      return DIR.DOWN;
    } else if (initialDirection === DIR.DOWN) {
      return DIR.UP;
    } else if (initialDirection === DIR.RIGHT) {
      return DIR.LEFT;
    } else if (initialDirection === DIR.LEFT) {
      return DIR.RIGHT;
    } else {
      return DIR.LEFT;
    }
  };

  return ViewNavigationController;

})(Layer);


},{}]},{},[])
//# sourceMappingURL=data:application/json;charset:utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm5vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCIvVXNlcnMvb25seW15dGhvL0RvY3VtZW50cy9mcmFtZXIvbW9kdWxlcy9mcmFtZXItdmlld05hdmlnYXRpb25Db250cm9sbGVyLW1hc3Rlci92bmMtZXhhbXBsZTAxLmZyYW1lci9tb2R1bGVzL1ZpZXdOYXZpZ2F0aW9uQ29udHJvbGxlci5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUE7QUNBQSxJQUFBOzs7QUFBTSxPQUFPLENBQUM7QUFHYixNQUFBOzs7O0VBQUEsaUJBQUEsR0FBb0I7O0VBQ3BCLG9CQUFBLEdBQXVCOztFQUN2QixpQkFBQSxHQUNDO0lBQUEsSUFBQSxFQUFNLEdBQU47SUFDQSxLQUFBLEVBQU8sYUFEUDs7O0VBRUQsaUJBQUEsR0FDQztJQUFBLENBQUEsRUFBRyxDQUFIO0lBQ0EsQ0FBQSxFQUFHLEVBREg7SUFFQSxLQUFBLEVBQU8sRUFGUDtJQUdBLE1BQUEsRUFBUSxFQUhSOzs7RUFJRCxJQUFBLEdBQ0M7SUFBQSxFQUFBLEVBQVEsUUFBUjtJQUNBLElBQUEsRUFBUSxVQURSO0lBRUEsSUFBQSxFQUFRLFVBRlI7SUFHQSxLQUFBLEVBQVEsV0FIUjtJQUlBLE1BQUEsRUFBUSxZQUpSOzs7RUFLRCxHQUFBLEdBQ0M7SUFBQSxFQUFBLEVBQU8sSUFBUDtJQUNBLElBQUEsRUFBTyxNQURQO0lBRUEsSUFBQSxFQUFPLE1BRlA7SUFHQSxLQUFBLEVBQU8sT0FIUDs7O0VBSUQsVUFBQSxHQUFhOztFQUdBLGtDQUFDLE9BQUQ7QUFFWixRQUFBO0lBRmEsSUFBQyxDQUFBLDRCQUFELFVBQVM7SUFFdEIsSUFBQyxDQUFBLEtBQUQsR0FBUyxJQUFDLENBQUEsT0FBRCxHQUFXLElBQUMsQ0FBQSxXQUFELEdBQWUsSUFBQyxDQUFBLFdBQUQsR0FBZSxJQUFDLENBQUEsWUFBRCxHQUFnQixJQUFDLENBQUEsZ0JBQUQsR0FBb0IsSUFBQyxDQUFBLGVBQUQsR0FB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dGVkLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXNDb250ZW50IjpbIihmdW5jdGlvbiBlKHQsbixyKXtmdW5jdGlvbiBzKG8sdSl7aWYoIW5bb10pe2lmKCF0W29dKXt2YXIgYT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2lmKCF1JiZhKXJldHVybiBhKG8sITApO2lmKGkpcmV0dXJuIGkobywhMCk7dmFyIGY9bmV3IEVycm9yKFwiQ2Fubm90IGZpbmQgbW9kdWxlICdcIitvK1wiJ1wiKTt0aHJvdyBmLmNvZGU9XCJNT0RVTEVfTk9UX0ZPVU5EXCIsZn12YXIgbD1uW29dPXtleHBvcnRzOnt9fTt0W29dWzBdLmNhbGwobC5leHBvcnRzLGZ1bmN0aW9uKGUpe3ZhciBuPXRbb11bMV1bZV07cmV0dXJuIHMobj9uOmUpfSxsLGwuZXhwb3J0cyxlLHQsbixyKX1yZXR1cm4gbltvXS5leHBvcnRzfXZhciBpPXR5cGVvZiByZXF1aXJlPT1cImZ1bmN0aW9uXCImJnJlcXVpcmU7Zm9yKHZhciBvPTA7bzxyLmxlbmd0aDtvKyspcyhyW29dKTtyZXR1cm4gc30pIiwiY2xhc3MgZXhwb3J0cy5WaWV3TmF2aWdhdGlvbkNvbnRyb2xsZXIgZXh0ZW5kcyBMYXllclxuXG5cdCMgU2V0dXAgQ2xhc3MgQ29uc3RhbnRzXG5cdElOSVRJQUxfVklFV19OQU1FID0gXCJpbml0aWFsVmlld1wiXG5cdEJBQ0tCVVRUT05fVklFV19OQU1FID0gXCJ2bmMtYmFja0J1dHRvblwiXG5cdEFOSU1BVElPTl9PUFRJT05TID0gXG5cdFx0dGltZTogMC4zXG5cdFx0Y3VydmU6IFwiZWFzZS1pbi1vdXRcIlxuXHRCQUNLX0JVVFRPTl9GUkFNRSA9IFxuXHRcdHg6IDBcblx0XHR5OiA0MFxuXHRcdHdpZHRoOiA4OFxuXHRcdGhlaWdodDogODhcblx0UFVTSCA9XG5cdFx0VVA6ICAgICBcInB1c2hVcFwiXG5cdFx0RE9XTjogICBcInB1c2hEb3duXCJcblx0XHRMRUZUOiAgIFwicHVzaExlZnRcIlxuXHRcdFJJR0hUOiAgXCJwdXNoUmlnaHRcIlxuXHRcdENFTlRFUjogXCJwdXNoQ2VudGVyXCJcblx0RElSID1cblx0XHRVUDogICAgXCJ1cFwiXG5cdFx0RE9XTjogIFwiZG93blwiXG5cdFx0TEVGVDogIFwibGVmdFwiXG5cdFx0UklHSFQ6IFwicmlnaHRcIlxuXHRERUJVR19NT0RFID0gZmFsc2Vcblx0XHRcblx0IyBTZXR1cCBJbnN0YW5jZSBhbmQgSW5zdGFuY2UgVmFyaWFibGVzXHRcblx0Y29uc3RydWN0b3I6IChAb3B0aW9ucz17fSkgLT5cblxuXHRcdEB2aWV3cyA9IEBoaXN0b3J5ID0gQGluaXRpYWxWaWV3ID0gQGN1cnJlbnRWaWV3ID0gQHByZXZpb3VzVmlldyA9IEBhbmltYXRpb25PcHRpb25zID0gQGluaXRpYWxWaWV3TmFtZSA9IG51bGxcblx0XHRAb3B0aW9ucy53aWR0aCAgICAgICAgICAgPz0gU2NyZWVuLndpZHRoXG5cdFx0QG9wdGlvbnMuaGVpZ2h0ICAgICAgICAgID89IFNjcmVlbi5oZWlnaHRcblx0XHRAb3B0aW9ucy5jbGlwICAgICAgICAgICAgPz0gdHJ1ZVxuXHRcdEBvcHRpb25zLmJhY2tncm91bmRDb2xvciA/PSBcIiM5OTlcIlxuXHRcdFxuXHRcdHN1cGVyIEBvcHRpb25zXG5cdFx0XG5cdFx0QHZpZXdzICAgPSBbXVxuXHRcdEBoaXN0b3J5ID0gW11cblx0XHRAYW5pbWF0aW9uT3B0aW9ucyA9IEBvcHRpb25zLmFuaW1hdGlvbk9wdGlvbnMgb3IgQU5JTUFUSU9OX09QVElPTlNcblx0XHRAaW5pdGlhbFZpZXdOYW1lICA9IEBvcHRpb25zLmluaXRpYWxWaWV3TmFtZSAgb3IgSU5JVElBTF9WSUVXX05BTUVcblx0XHRAYmFja0J1dHRvbkZyYW1lICA9IEBvcHRpb25zLmJhY2tCdXR0b25GcmFtZSAgb3IgQkFDS19CVVRUT05fRlJBTUVcblxuXHRcdEBkZWJ1Z01vZGUgPSBpZiBAb3B0aW9ucy5kZWJ1Z01vZGU/IHRoZW4gQG9wdGlvbnMuZGVidWdNb2RlIGVsc2UgREVCVUdfTU9ERVxuXHRcdFxuXHRcdEAub24gXCJjaGFuZ2U6c3ViTGF5ZXJzXCIsIChjaGFuZ2VMaXN0KSAtPlxuXHRcdFx0VXRpbHMuZGVsYXkgMCwgPT5cblx0XHRcdFx0QGFkZFZpZXcgc3ViTGF5ZXIsIHRydWUgZm9yIHN1YkxheWVyIGluIGNoYW5nZUxpc3QuYWRkZWRcblxuXHRhZGRWaWV3OiAodmlldywgdmlhSW50ZXJuYWxDaGFuZ2VFdmVudCkgLT5cblx0XHRcblx0XHR2bmNXaWR0aCAgPSBAb3B0aW9ucy53aWR0aFxuXHRcdHZuY0hlaWdodCA9IEBvcHRpb25zLmhlaWdodFxuXG5cdFx0dmlldy5zdGF0ZXMuYWRkXG5cdFx0XHRcIiN7IFBVU0guVVAgfVwiOlxuXHRcdFx0XHR4OiAwXG5cdFx0XHRcdHk6IC12bmNIZWlnaHRcblx0XHRcdFwiI3sgUFVTSC5MRUZUIH1cIjpcblx0XHRcdFx0eDogLXZuY1dpZHRoXG5cdFx0XHRcdHk6IDBcblx0XHRcdFwiI3sgUFVTSC5DRU5URVIgfVwiOlxuXHRcdFx0XHR4OiAwXG5cdFx0XHRcdHk6IDBcblx0XHRcdFwiI3sgUFVTSC5SSUdIVCB9XCI6XG5cdFx0XHRcdHg6IHZuY1dpZHRoXG5cdFx0XHRcdHk6IDBcblx0XHRcdFwiI3sgUFVTSC5ET1dOIH1cIjpcblx0XHRcdFx0eDogMFxuXHRcdFx0XHR5OiB2bmNIZWlnaHRcblx0XHRcdFxuXHRcdHZpZXcuc3RhdGVzLmFuaW1hdGlvbk9wdGlvbnMgPSBAYW5pbWF0aW9uT3B0aW9uc1xuXHRcdFxuXHRcdGlmIHZpZXcubmFtZSBpcyBAaW5pdGlhbFZpZXdOYW1lXG5cdFx0XHRAaW5pdGlhbFZpZXcgPSB2aWV3XG5cdFx0XHRAY3VycmVudFZpZXcgPSB2aWV3XG5cdFx0XHR2aWV3LnN0YXRlcy5zd2l0Y2hJbnN0YW50IFBVU0guQ0VOVEVSXG5cdFx0XHRAaGlzdG9yeS5wdXNoIHZpZXdcblx0XHRlbHNlXG5cdFx0XHR2aWV3LnN0YXRlcy5zd2l0Y2hJbnN0YW50IFBVU0guUklHSFRcblx0XHRcblx0XHR1bmxlc3Mgdmlldy5zdXBlckxheWVyIGlzIEAgb3IgdmlhSW50ZXJuYWxDaGFuZ2VFdmVudFxuXHRcdFx0dmlldy5zdXBlckxheWVyID0gQFxuXHRcdFx0XG5cdFx0QF9hcHBseUJhY2tCdXR0b24gdmlldyB1bmxlc3Mgdmlldy5uYW1lIGlzIEBpbml0aWFsVmlld05hbWVcblx0XHRcdFxuXHRcdEB2aWV3cy5wdXNoIHZpZXdcblxuXHR0cmFuc2l0aW9uOiAodmlldywgZGlyZWN0aW9uID0gRElSLlJJR0hULCBzd2l0Y2hJbnN0YW50ID0gZmFsc2UsIHByZXZlbnRIaXN0b3J5ID0gZmFsc2UpIC0+XG5cblx0XHRyZXR1cm4gZmFsc2UgaWYgdmlldyBpcyBAY3VycmVudFZpZXdcblx0XHRcblx0XHQjIFNldHVwIFZpZXdzIGZvciB0aGUgdHJhbnNpdGlvblxuXHRcdGlmIGRpcmVjdGlvbiBpcyBESVIuUklHSFRcblx0XHRcdHZpZXcuc3RhdGVzLnN3aXRjaEluc3RhbnQgIFBVU0guUklHSFRcblx0XHRcdEBjdXJyZW50Vmlldy5zdGF0ZXMuc3dpdGNoIFBVU0guTEVGVFxuXHRcdGVsc2UgaWYgZGlyZWN0aW9uIGlzIERJUi5ET1dOXG5cdFx0XHR2aWV3LnN0YXRlcy5zd2l0Y2hJbnN0YW50ICBQVVNILkRPV05cblx0XHRcdEBjdXJyZW50Vmlldy5zdGF0ZXMuc3dpdGNoIFBVU0guVVBcblx0XHRlbHNlIGlmIGRpcmVjdGlvbiBpcyBESVIuTEVGVFxuXHRcdFx0dmlldy5zdGF0ZXMuc3dpdGNoSW5zdGFudCAgUFVTSC5MRUZUXG5cdFx0XHRAY3VycmVudFZpZXcuc3RhdGVzLnN3aXRjaCBQVVNILlJJR0hUXG5cdFx0ZWxzZSBpZiBkaXJlY3Rpb24gaXMgRElSLlVQXG5cdFx0XHR2aWV3LnN0YXRlcy5zd2l0Y2hJbnN0YW50ICBQVVNILlVQXG5cdFx0XHRAY3VycmVudFZpZXcuc3RhdGVzLnN3aXRjaCBQVVNILkRPV05cblx0XHRlbHNlXG5cdFx0XHQjIElmIHRoZXkgc3BlY2lmaWVkIHNvbWV0aGluZyBkaWZmZXJlbnQganVzdCBzd2l0Y2ggaW1tZWRpYXRlbHlcblx0XHRcdHZpZXcuc3RhdGVzLnN3aXRjaEluc3RhbnQgUFVTSC5DRU5URVJcblx0XHRcdEBjdXJyZW50Vmlldy5zdGF0ZXMuc3dpdGNoSW5zdGFudCBQVVNILkxFRlRcblx0XHRcblx0XHQjIFB1c2ggdmlldyB0byBDZW50ZXJcblx0XHR2aWV3LnN0YXRlcy5zd2l0Y2ggUFVTSC5DRU5URVJcblx0XHQjIGN1cnJlbnRWaWV3IGlzIG5vdyBvdXIgcHJldmlvdXNWaWV3XG5cdFx0QHByZXZpb3VzVmlldyA9IEBjdXJyZW50Vmlld1xuXHRcdCMgU2F2ZSB0cmFuc2l0aW9uIGRpcmVjdGlvbiB0byB0aGUgbGF5ZXIncyBjdXN0b20gcHJvcGVydGllc1xuXHRcdEBwcmV2aW91c1ZpZXcuY3VzdG9tID1cblx0XHRcdGxhc3RUcmFuc2l0aW9uOiBkaXJlY3Rpb25cblx0XHQjIFNldCBvdXIgY3VycmVudFZpZXcgdG8gdGhlIHZpZXcgd2UndmUgYnJvdWdodCBpblxuXHRcdEBjdXJyZW50VmlldyA9IHZpZXdcblxuXHRcdCMgU3RvcmUgdGhlIGxhc3QgdmlldyBpbiBoaXN0b3J5XG5cdFx0QGhpc3RvcnkucHVzaCBAcHJldmlvdXNWaWV3IGlmIHByZXZlbnRIaXN0b3J5IGlzIGZhbHNlXG5cdFx0XG5cdFx0IyBFbWl0IGFuIGV2ZW50IHNvIHRoZSBwcm90b3R5cGUgY2FuIHJlYWN0IHRvIGEgdmlldyBjaGFuZ2Vcblx0XHRAZW1pdCBcImNoYW5nZTp2aWV3XCJcblxuXHRyZW1vdmVCYWNrQnV0dG9uOiAodmlldykgLT5cblx0XHRVdGlscy5kZWxheSAwLCA9PlxuXHRcdFx0dmlldy5zdWJMYXllcnNCeU5hbWUoQkFDS0JVVFRPTl9WSUVXX05BTUUpWzBdLnZpc2libGUgPSBmYWxzZVxuXG5cdGJhY2s6ICgpIC0+XG5cdFx0bGFzdFZpZXcgPSBAX2dldExhc3RIaXN0b3J5SXRlbSgpXG5cdFx0bGFzdFRyYW5zaXRpb24gPSBsYXN0Vmlldy5jdXN0b20ubGFzdFRyYW5zaXRpb25cblx0XHRvcHBvc2l0ZVRyYW5zaXRpb24gPSBAX2dldE9wcG9zaXRlRGlyZWN0aW9uKGxhc3RUcmFuc2l0aW9uKVxuXHRcdEB0cmFuc2l0aW9uKGxhc3RWaWV3LCBkaXJlY3Rpb24gPSBvcHBvc2l0ZVRyYW5zaXRpb24sIHN3aXRjaEluc3RhbnQgPSBmYWxzZSwgcHJldmVudEhpc3RvcnkgPSB0cnVlKVxuXHRcdEBoaXN0b3J5LnBvcCgpXG5cblx0X2dldExhc3RIaXN0b3J5SXRlbTogKCkgLT5cblx0XHRyZXR1cm4gQGhpc3RvcnlbQGhpc3RvcnkubGVuZ3RoIC0gMV1cblxuXHRfYXBwbHlCYWNrQnV0dG9uOiAodmlldywgZnJhbWUgPSBAYmFja0J1dHRvbkZyYW1lKSAtPlxuXHRcdFV0aWxzLmRlbGF5IDAsID0+XG5cdFx0XHRpZiB2aWV3LmJhY2tCdXR0b24gaXNudCBmYWxzZVxuXHRcdFx0XHRiYWNrQnV0dG9uID0gbmV3IExheWVyXG5cdFx0XHRcdFx0bmFtZTogQkFDS0JVVFRPTl9WSUVXX05BTUVcblx0XHRcdFx0XHR3aWR0aDogODBcblx0XHRcdFx0XHRoZWlnaHQ6IDgwXG5cdFx0XHRcdFx0c3VwZXJMYXllcjogdmlld1xuXG5cdFx0XHRcdGlmIEBkZWJ1Z01vZGUgaXMgZmFsc2Vcblx0XHRcdFx0XHRiYWNrQnV0dG9uLmJhY2tncm91bmRDb2xvciA9IFwidHJhbnNwYXJlbnRcIlxuXG5cdFx0XHRcdGJhY2tCdXR0b24uZnJhbWUgPSBmcmFtZVxuXG5cdFx0XHRcdGJhY2tCdXR0b24ub24gRXZlbnRzLkNsaWNrLCA9PlxuXHRcdFx0XHRcdEBiYWNrKClcblxuXHRfZ2V0T3Bwb3NpdGVEaXJlY3Rpb246IChpbml0aWFsRGlyZWN0aW9uKSAtPlxuXHRcdGlmIGluaXRpYWxEaXJlY3Rpb24gaXMgRElSLlVQXG5cdFx0XHRyZXR1cm4gRElSLkRPV05cblx0XHRlbHNlIGlmIGluaXRpYWxEaXJlY3Rpb24gaXMgRElSLkRPV05cblx0XHRcdHJldHVybiBESVIuVVBcblx0XHRlbHNlIGlmIGluaXRpYWxEaXJlY3Rpb24gaXMgRElSLlJJR0hUXG5cdFx0XHRyZXR1cm4gRElSLkxFRlRcblx0XHRlbHNlIGlmIGluaXRpYWxEaXJlY3Rpb24gaXMgRElSLkxFRlRcblx0XHRcdHJldHVybiBESVIuUklHSFRcblx0XHRlbHNlXG5cdFx0XHRyZXR1cm4gRElSLkxFRlRcblx0XHRcbiAgICBcblxuIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcbiMgVVNBR0UgRVhBTVBMRSAxIC0gRGVmaW5lIEluaXRpYWxWaWV3TmFtZSAjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cbiMgaW5pdGlhbFZpZXdLZXkgPSBcInZpZXcxXCJcbiMgXG4jIHZuYyA9IG5ldyBWaWV3TmF2aWdhdGlvbkNvbnRyb2xsZXIgaW5pdGlhbFZpZXdOYW1lOiBpbml0aWFsVmlld0tleVxuIyB2aWV3MSA9IG5ldyBMYXllclxuIyBcdG5hbWU6IGluaXRpYWxWaWV3S2V5XG4jIFx0d2lkdGg6ICBTY3JlZW4ud2lkdGhcbiMgXHRoZWlnaHQ6IFNjcmVlbi5oZWlnaHRcbiMgXHRiYWNrZ3JvdW5kQ29sb3I6IFwicmVkXCJcbiMgXHRwYXJlbnQ6IHZuY1xuXG4jIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuIyBVU0FHRSBFWEFNUExFIDIgLSBVc2UgZGVmYXVsdCBpbml0aWFsVmlld05hbWUgXCJpbml0aWFsVmlld1wiICMjIyMjIyMjIyMjIyMjIyMjI1xuXG4jIHZuYyA9IG5ldyBWaWV3TmF2aWdhdGlvbkNvbnRyb2xsZXJcblxuIyB2aWV3MSA9IG5ldyBMYXllclxuIyBcdG5hbWU6IFwiaW5pdGlhbFZpZXdcIlxuIyBcdHdpZHRoOiAgU2NyZWVuLndpZHRoXG4jIFx0aGVpZ2h0OiBTY3JlZW4uaGVpZ2h0XG4jIFx0YmFja2dyb3VuZENvbG9yOiBcInJlZFwiXG4jIFx0cGFyZW50OiB2bmNcblx0XG4jIHZpZXcyID0gbmV3IExheWVyXG4jIFx0d2lkdGg6ICBTY3JlZW4ud2lkdGhcbiMgXHRoZWlnaHQ6IFNjcmVlbi5oZWlnaHRcbiMgXHRiYWNrZ3JvdW5kQ29sb3I6IFwiZ3JlZW5cIlxuIyBcdHBhcmVudDogdm5jXG5cbiMgdmlldzEub24gRXZlbnRzLkNsaWNrLCAtPiB2bmMudHJhbnNpdGlvbiB2aWV3MlxuIyB2aWV3Mi5vbiBFdmVudHMuQ2xpY2ssIC0+IHZuYy5iYWNrKClcblx0Il19
