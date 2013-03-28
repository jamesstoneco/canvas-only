###

Using the element of Form in Creative Coding by using Grids. Based on example 2.1.2 in Generative Design. (http://www.generative-gestaltung.de/P_2_1_2_02)
###

coffee_draw = (p5) ->
  tileCount = 10
  actRandomSeed = 0
  backColor = p5.color(255)
  
  moduleColorBackground = p5.color(0)
  moduleColorForeground = p5.color(255)

  moduleAlphaBackground = 100
  moduleAlphaForeground = 100

  moduleRadiusBackground = 30
  moduleRadiusForeground = 15

  p5.setup = () ->
    p5.size $(window).width(), $(window).height()
    
  p5.draw = () ->
    # p5.rectMode(p5.CENTER)
    p5.translate(p5.width/tileCount/2, p5.height/tileCount/2)
    p5.colorMode(p5.HSB, 360, 100, 100, 100)
    p5.background(backColor)
    p5.smooth()
    p5.noStroke()
    p5.randomSeed(actRandomSeed)
    # background ellipse
    for gridY in [0..tileCount] by 1
      for gridX in [0..tileCount] by 1
        posX = p5.width/tileCount * gridX
        posY = p5.height/tileCount * gridY
        shiftX = p5.random(-1,1)*p5.mouseX/20
        shiftY = p5.random(-1,1)*p5.mouseY/20
        p5.fill(moduleColorBackground, moduleAlphaBackground)
        p5.ellipse(posX+shiftX, posY+shiftY, moduleRadiusBackground, moduleRadiusBackground)
    # foreground ellipse
    for gridY in [0..tileCount] by 1
      for gridX in [0..tileCount] by 1
        posX = p5.width/tileCount * gridX
        posY = p5.height/tileCount * gridY
        p5.fill(moduleColorForeground, moduleAlphaForeground)
        p5.ellipse(posX, posY, moduleRadiusForeground, moduleRadiusForeground)
  p5.mousePressed = () ->
    actRandomSeed = p5.floor(p5.random(100000))


### do not edit below ###

# change canvas / processing sketch size to match resized window, note restarts sketch
$(window).resize ->
  processing.size $(window).width(), $(window).height()

$(document).ready ->
  canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw