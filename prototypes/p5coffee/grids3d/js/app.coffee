###

Using the element of Form in Creative Coding by using Grids. Based on example 2.1.2 in Generative Design. (http://www.generative-gestaltung.de/P_2_1_2_02)

###

coffee_draw = (p5) ->
  myVector = new toxi.geom.Vec2D(window.innerWidth,window.innerHeight).scaleSelf(0.5)
  myVector2 = new toxi.geom.Ve2D(0.5,0.5)
  myColor = new toxi.color.TColor.newRGB(128/255,64/255,32/255)

  p5.setup = () ->
    p5.size $(window).width(), $(window).height()
    
  p5.draw = () ->
  

### do not edit below ###

# change canvas / processing sketch size to match resized window, note restarts sketch
$(window).resize ->
  processing.size $(window).width(), $(window).height()

$(document).ready ->
  canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw