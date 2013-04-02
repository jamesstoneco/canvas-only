coffee_draw = (p5) ->
  class FlatShape
    constructor: (opts) ->
      @x = opts.x
      @y = opts.y
      @r = opts.r
      @sides = opts.sides
      @rotation = opts.rotation
      @color = opts.color
      @rotValue = 0.0;
    calc: ->
      @rotValue += @rotation
    drawShape: (x, y, r, sides) ->
      theta = 0;
      theta_inc = 2 * p5.PI / sides
      p5.pushMatrix()
      p5.translate(x,y)
      p5.beginShape()
      for i in [1..sides] by 1
        p5.rotate(@rotValue)
        calcx = r * p5.sin(theta)
        calcy = r * p5.cos(theta)
        p5.vertex(calcx,calcy)
        theta += theta_inc
      p5.endShape(p5.CLOSE)
      p5.popMatrix()
    display: ->
      @calc()
      p5.fill(@color)
      p5.noStroke()
      @drawShape(@x, @y, @r, @sides)
  # globals
  t = 0.0;
  t_inc = 0.001;
  flatShapes = new Array();
  number_of_shapes = 25

  p5.setup = () ->
    p5.size $(window).width(), $(window).height()
    for i in [3..3+number_of_shapes-1] by 1
      s = new FlatShape
        x: i*p5.width/number_of_shapes
        y: p5.height/2
        r: p5.width/(number_of_shapes*2)
        sides: 7
        rotation: p5.random(-0.001, 0.001)
        color: p5.color(p5.random(0,255))
      flatShapes.push(s)
  p5.draw = () ->
    p5.background(127)
    p5.scale(0.9)
    p5.rectMode(p5.CENTER)
    p5.translate(-p5.width/(number_of_shapes)*2, 0)
    # t+=t_inc
    p5.rotate(p5.sin(p5.frameCount/100)*p5.PI/12)
    for s in flatShapes
      if p5.frameCount % 100 == 0 then s.rotation = p5.random(-0.01, 0.01)
      s.display()
  p5.mousePressed = () ->
    for s in flatShapes
      s.color = p5.color(p5.random(0,255))

    

  
### do not edit blow ###

# change canvas / processing sketch size to match resized window, note restarts sketch
$(window).resize ->
  processing.size $(window).width(), $(window).height()

$(document).ready ->
  canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw