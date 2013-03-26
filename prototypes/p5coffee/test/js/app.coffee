coffee_draw = (p5) ->
  p5.setup = () ->
    p5.size 400, 400
    p5.background 0
    @beans = []
    
  p5.draw = () ->
    # p5.background 127
    p5.noStroke()

    # how to do easy looping??? in coffeescript

    # for circles in [0..100] do
    # iteration in coffeescript
    # http://www.jezng.com/2012/05/iteration-in-coffeescript/

    for i in [0..200] by 1
      circle_size = p5.random(10, 40)
      if circle_size < 30 then p5.fill 255, 0, 0 else p5.fill 0, 0, 255
      p5.ellipse p5.random(0, p5.width), p5.random(0, p5.height), circle_size, circle_size
    

class Bean
  constructor: (@p5, opts) ->
    @x = opts.x
    @y = opts.y
    
    @x_off = opts.x_off
    @y_off = opts.y_off
    
    @vel = opts.vel || 3
    @accel = opts.accel || -0.003
  
  draw: () ->
    return unless @vel > 0
    
    @x_off += 0.0007
    @y_off += 0.0007
    
    @vel += @accel
    
    @x += @p5.noise(@x_off) * @vel - @vel/2
    @y += @p5.noise(@y_off) * @vel - @vel/2
    
    @set_color()
    @p5.point @x, @y
    
    
  set_color: () ->
    @p5.colorMode(@p5.HSB, 360, 100, 100)
    
    h = @p5.noise((@x_off+@y_off)/2)*360
    s = 100
    b = 100
    a = 4
    
    @p5.stroke h, s, b, a

$(document).ready ->
  canvas = document.getElementById "p5canvas"
  processing = new Processing canvas, coffee_draw
