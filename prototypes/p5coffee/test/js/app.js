// Generated by CoffeeScript 1.4.0
var Bean, coffee_draw;

coffee_draw = function(p5) {
  p5.setup = function() {
    p5.size($(window).width(), $(window).height());
    return p5.background(0);
  };
  return p5.draw = function() {
    return p5.background(p5.frameCount);
  };
};

Bean = (function() {

  function Bean(p5, opts) {}

  return Bean;

})();

$(document).ready(function() {
  var canvas, processing;
  canvas = document.getElementById("processing");
  return processing = new Processing(canvas, coffee_draw);
});
