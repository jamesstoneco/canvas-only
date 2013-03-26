coffee_draw = (p5) ->
  
  p5.setup = () ->
    p5.size $(window).width(), $(window).height()
    
  p5.draw = () ->
    p5.noStroke()
    # for i in [0..20] by 1
    circle_size = p5.random(10, 40)
    if circle_size < 30 then p5.fill 255, 0, 0 else p5.fill 0, 0, 255
    p5.ellipse p5.random(0, p5.width), p5.random(0, p5.height), circle_size, circle_size

### do not edit below ###

# change canvas / processing sketch size to match resized window, note restarts sketch
$(window).resize ->
  processing.size $(window).width(), $(window).height()

$(document).ready ->
  canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw