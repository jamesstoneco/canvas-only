class window.UIElement
  constructor: (p5, opts) ->
    @loc = new p5.PVector(opts.x, opts.y)
    if 0 < opts.width < p5.width then @width = opts.width else @width = 10
    if 0 < opts.height < p5.height then @height = opts.height else @height = 10
    @color = opts.color
    @name = opts.name
  within: (targetX, targetY) ->
    x1 = @loc.x - @width/2
    x2 = @loc.x + @width/2
    y1 = @loc.y - @height/2
    y2 = @loc.y + @height/2
    ((x1 < targetX < x2) && (y1 < targetY < y2))
  display(p5): ->
    p5.rectMode(p5.CENTER)
    p5.noStroke
    if @within(p5.mouseX, p5.mouseY) then p5.fill(@color, 255) else p5.fill(@color, 180)
    p5.rect(@loc.x, @loc.y, @width, @height)
class window.UIBang extends UIElement
  constructor: (p5, opts) ->
    super(p5, opts)
class window.UIToggle extends UIElement
  constructor: (p5, opts) ->
    super(p5, opts)
    @state = opts.state
