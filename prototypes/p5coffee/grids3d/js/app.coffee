###

Using the element of Form in Creative Coding by using Grids. Based on example 2.1.2 in Generative Design. (http://www.generative-gestaltung.de/P_2_1_2_02)
###

coffee_draw = (p5) ->
  tileCount = 4
  actRandomSeed = 0
  backColor = p5.color(255)
  
  moduleColorBackground = p5.color(127)
  moduleColorForeground = p5.color(0)

  moduleRadiusBackground = 150
  moduleRadiusForeground = 100
  yRot = 0.0
  yRotInc = 0.001

  p5.setup = () ->
    p5.size $(window).width(), $(window).height(), p5.OPENGL
    
  p5.draw = () ->
    # myLights()
#    p5.lights()
    p5.translate(0,0, -300)
    p5.translate(p5.width/2, p5.height/2, 0)
    p5.rotateX(yRot+=yRotInc)
    p5.rotateY(yRot)
    p5.rotateZ(yRot)
    p5.rectMode(p5.CENTER)
    p5.translate(-p5.width/2, -p5.height/2, 0)
    p5.translate(p5.width/tileCount/2, p5.height/tileCount/2)
    p5.colorMode(p5.HSB, 360, 100, 100, 100)
    p5.background(backColor)
#    p5.noStroke()
    p5.randomSeed(actRandomSeed)
    # foreground ellipse
    for gridY in [0..tileCount-1] by 1
      for gridX in [0..tileCount-1] by 1
        for gridZ in [0..tileCount-1] by 1
          posX = p5.width/tileCount * gridX
          posY = p5.height/tileCount * gridY
          posZ = p5.height/tileCount * gridZ * 2
          p5.fill(moduleColorForeground)
          p5.pushMatrix()
          p5.translate(posX, posY, -posZ)
          p5.box(moduleRadiusForeground)
          p5.popMatrix()
    # background ellipse
    p5.translate(0,0,-moduleRadiusForeground*1.2)
    for gridY in [0..tileCount-1] by 1
      for gridX in [0..tileCount-1] by 1
        for gridZ in [0..tileCount-1] by 1
          posX = p5.width/tileCount * gridX
          posY = p5.height/tileCount * gridY
          posZ = p5.height/tileCount * gridZ *2
          shiftX = p5.random(-1,1)*p5.mouseX/20
          shiftY = p5.random(-1,1)*p5.mouseY/20
          p5.fill(moduleColorBackground)
          p5.pushMatrix()
          p5.translate(posX+shiftX, posY+shiftY, -posZ)
          p5.box(moduleRadiusBackground)
          p5.popMatrix()
  p5.mousePressed = () ->
    actRandomSeed = p5.floor(p5.random(100000))


### do not edit below ###

# change canvas / processing sketch size to match resized window, note restarts sketch
$(window).resize ->
  processing.size $(window).width(), $(window).height()

$(document).ready ->
  canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw