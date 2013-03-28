###

Simple demonstration of 3 modes of drawing, simular to my projection processing code exhibited in Phytodynamica, by James Stone (www.jamesjamesjames.com)

###

coffee_draw = (p5) ->
  drawMode = 0

  circles = () ->
    p5.noStroke()
    for i in [0..20] by 1
      circle_size = p5.random(10, 40)
      if circle_size < 30 then p5.fill 255, 0, 0 else p5.fill 0, 0, 255
      p5.ellipse p5.random(0, p5.width), p5.random(0, p5.height), circle_size, circle_size
  
  lines = () ->
    for i in [0..10] by 1
      if p5.random(0,1) > 0.3 then p5.stroke 255, 0, 0 else p5.stroke 0, 0, 255
      xLoc = p5.random(0, p5.width)
      p5.line xLoc, 0, xLoc, p5.height
  
  linesHoriz = () ->
    for i in [0..10] by 1
      if p5.random(0,1) > 0.3 then p5.stroke 255, 0, 0 else p5.stroke 0, 0, 255
      yLoc = p5.random(0, p5.height)
      p5.line 0, yLoc, p5.width, yLoc
  
  p5.setup = () ->
    p5.size $(window).width(), $(window).height()
    
  p5.draw = () ->
    switch drawMode
      when 0 then circles()
      when 1 then lines()
      when 2 then linesHoriz()
    drawMode = p5.floor(p5.random(0,3)) if p5.frameCount % 200 == 0 

### do not edit below ###

# change canvas / processing sketch size to match resized window, note restarts sketch
$(window).resize ->
  processing.size $(window).width(), $(window).height()

$(document).ready ->
  canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw