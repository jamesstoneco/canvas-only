canvas = document.getElementById 'glibcanvas'
p5 = new Processing(canvas)
value = 0
p5.setup = ->
  p5.size 200, 200
  p5.noLoop()
p5.draw = ->
  p5.noStroke()
  p5.fill 255, 75
  p5.rect 0, 0, 200, 200
  p5.stroke 100, 100, 200
  p5.noFill()
  p5.bezier 0, 100, 33, 100 + value, 66, 100 + value, 100, 100
  p5.bezier 100, 100, 133, 100 + -value, 166, 100 + -value, 200, 100
p5.mouseMoved = ->
  value = p5.mouseY - 100
  p5.redraw()
p5.setup()