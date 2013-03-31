coffee_draw = (p5) ->
  backgroundUI = (bgColor, xOff, yOff) ->
    # for a fast bg redraw
    # window.context.clearRect(0, 60, canvas.width, canvas.height);
    window.context.fillStyle = bgColor;
    window.context.fillRect(xOff, yOff, p5.width, p5.height);
  p5.setup = ->
    p5.size $(window).width(), $(window).height()
    p5.rectMode(p5.CENTER)
    # p5.smooth()
  p5.draw = ->
    backgroundUI "#eee", 0, 60
    size = 200+p5.sin(p5.frameCount/100)*100
    p5.noStroke()
    p5.fill(127, 127)
    p5.rect p5.width/2, p5.height/2, size, size

### zebra ui below ###
zebra.ready ->
  eval zebra.Import("ui", "layout")
  window.root = (new zCanvas("p5canvas")).root.properties
    layout: new BorderLayout(8, 8)
    background: "#eee"
    kids:
      TOP: new Panel
#        layout: new GridLayout(4,4,12)
        layout: new FlowLayout(CENTER, TOP, HORIZONTAL, 10)
        padding: 10
        background: "#eee"
        kids:
          "test1" : new Button().properties
            canHaveFocus: false
          "test2" : new Button("test 2").properties
            canHaveFocus: false
            id: "test2"
          "slider": new Slider()
          "check": new Checkbox("valueCheck")
#    myButton = window.root.find("//Button")

###
  create interactions for button presses
  create slider
  have data update slide
###
  
###
# alternative style from js
  root.setLayout(newBorderLayout(4,4))
  root.setPadding(4)
  p = new Button("Test")
  # p.setBackground("#00FF00")
  root.add(BOTTOM, p)
###

  


### do not edit below ###

# change canvas / processing sketch size to match resized window, note restarts sketch

$(window).resize ->
  processing.size $(window).width(), $(window).height()
  window.root.repaint()
  # need to call resize window to the ui?


$(document).ready ->
  window.canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw
  window.context = canvas.getContext('2d')
