coffee_draw = (p5) ->
  p5.setup = () ->
    p5.size $(window).width(), $(window).height()
  p5.draw = () ->
    p5.rectMode p5.CENTER
    # clears out the ui, can use a rect
    # p5.background(127)
    size = 200+p5.sin(p5.frameCount/100)*100
    p5.rect p5.width/2, p5.height/2, size, size

### zebra ui below ###
zebra.ready ->
  
  # import all classes, functions, constants
  # from zebra.ui, zebra.layout packages
  eval zebra.Import("ui", "layout")
  
  # create canvas
  root = (new zCanvas("p5canvas")).root
  root.properties
    layout: new BorderLayout(8, 8)
    border: new Border()
    padding: 8
    kids:
      TOP: new Button("Top").properties
        canHaveFocus: false
      LEFT: new Button("Left").properties
        canHaveFocus: false
      RIGHT: new Button("Right").properties
        canHaveFocus: false
      BOTTOM: new Button("bottom").properties
        canHaveFocus: false

  root.find("//Button")._.add ->
    root.find("//TextField").setValue ""



### do not edit below ###

# change canvas / processing sketch size to match resized window, note restarts sketch
###
$(window).resize ->
  processing.size $(window).width(), $(window).height()
###

$(document).ready ->
  canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw
