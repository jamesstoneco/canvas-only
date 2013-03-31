coffee_draw = (p5) ->
  # class def
  class Cubist
      constructor: (opts) ->
        @loc = new p5.PVector(opts.x, opts.y) # or -> toxi.geom.Vec2D(300, 300)
        @vel = new p5.PVector(opts.velx, opts.vely)
        @size = opts.size
        @color = opts.color
        @alpha = opts.alpha
      calc: ->
        @jitter()
        @loc.add(@vel)
        # if out of bounds, flip vector
        @vel.x = -@vel.x if @loc.x < 0 || @loc.x > p5.width
        @vel.y = -@vel.y if @loc.y < 0 || @loc.y > p5.height
      jitter: ->
        jitAmt = 0.1
        tempVec = new p5.PVector(p5.random(-jitAmt, jitAmt), p5.random(-jitAmt, jitAmt))
        @vel.add(tempVec)
      display: ->
        p5.stroke(0, @alpha)
        p5.fill(@color, @alpha)
        p5.rect(@loc.x, @loc.y, @size, @size)

  # globals for p5
  cubistArr = new Array()

  p5.setup = () ->
    # p5.size $(window).width(), $(window).height()
    # p5.size 400, 400
    for i in [0..100] by 1
      cubist = new Cubist
        x: p5.random(0, p5.width), 
        y: p5.random(0,p5.height), 
        velx: p5.random(-1, 1),
        vely: p5.random(-1, 1),
        size: 100, 
        color: p5.color(p5.random(127, 255),0,0), 
        alpha: 3
      cubistArr.push(cubist)
      
  p5.draw = () ->
    cubist.calc() for cubist in cubistArr
    cubist.display() for cubist in cubistArr

### do not edit below ###

# change canvas / processing sketch size to match resized window, note restarts sketch
# $(window).resize ->
#  processing.size $(window).width(), $(window).height()

# $(document).ready ->
#   canvas = document.getElementById "p5canvas"
#   window.processing = new Processing canvas, coffee_draw

domready( ->
  window.canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw
  resizeSketch()
)

resizeSketch = -> 
  w = window
  d = document
  e = d.documentElement
  g = d.getElementsByTagName('body')[0]
  x = w.innerWidth || e.clientWidth || g.ClientWidth
  y = w.innerHeight || e.clientHeight || g.ClientHeight
  console.log x + " , " + y
  window.processing.size x, y

# window.onresize = alert "working"
  # resizeSketch()
