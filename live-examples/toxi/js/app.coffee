# loosly based on the colorwaves example by Kyle Philips (http://www.haptic-data.com/toxiclibsjs/examples/ColorWaves_raphael.html)

coffee_draw = (p5) ->
  # class def
  class Particle
    constructor: (opts) ->
      @loc = new toxi.geom.Vec2D(opts.x, opts.y)
      @vel = new toxi.geom.Vec2D(opts.velx, opts.vely)
      @height = opts.height
      @width = opts.width
    jitter: ->
      jitter_amt = 0.1
      @vel.x += p5.random(-jitter_amt, jitter_amt)
      @vel.y += p5.random(-jitter_amt, jitter_amt)
    calc: ->
      @loc = @loc.add(@vel)
      @jitter()
      @calc_color()
      # if out of bounds, flip vel
      if (@loc.x < 0 || @loc.x > p5.width) then @vel.x = -@vel.x
      if (@loc.y < 0 || @loc.y > p5.height) then @vel.y = -@vel.y
    calc_color: ->
      distance = @loc.distanceTo(new toxi.geom.Vec2D(p5.mouseX, p5.mouseY))
      tempColor = new toxi.color.TColor.newHSV(0.5, p5.frameCount/50*distance/p5.width, 1- p5.frameCount/50*distance/p5.width)
      @color = p5.color(tempColor.red()*255, tempColor.green()*255, tempColor.blue()*255)

    display: ->
      p5.rectMode p5.CENTER
      p5.noStroke()
      p5.fill(@color, 127)
      p5.rect(@loc.x, @loc.y, @width, @height)

  # globals for p5

  particles = new Array()
  number_of_particles = 2000

  p5.setup = () ->
    p5.size $(window).width(), $(window).height()

    for i in [1..number_of_particles] by 1
      p = new Particle
        x: p5.width/2
        y: p5.height/2
        velx: p5.random(-1, 1)
        vely: p5.random(-1, 1)
        height: 10
        width: 10
      particles.push(p)
    
      
  p5.draw = () ->
    # p5.background(200)
    for p in particles
      p.calc()
      p.display()

  
### do not edit blow ###

# change canvas / processing sketch size to match resized window, note restarts sketch
$(window).resize ->
  processing.size $(window).width(), $(window).height()

$(document).ready ->
  canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw