
coffee_draw = (p5) ->
  #class def
    
  #globals
  myBangs = new Array()
  
  p5.setup = ->
    p5.size $(window).width(), $(window).height()
    p5.rectMode(p5.CENTER)
    for i in [1..3] by 1
      bang = new window.UISimple.UIBang(p5,{
        x: p5.width/2+100*i-200
        y: 50
        width: 30
        height: 30
        color: p5.color(127)
        name: "bang"+i 
      })
      myBangs.push(bang)

  p5.draw = ->
    p5.background(200)
    size = 200+p5.sin(p5.frameCount/100)*100
    p5.noStroke()
    p5.fill(127, 127)
    p5.rect p5.width/2, p5.height/2, size, size
    b.display() for b in myBangs

  p5.mousePressed = ->
    for b in myBangs 
      if b.within(p5.mouseX, p5.mouseY)
        switch b.name
          when "bang1" then b.color = p5.color(255,0,0)
          when "bang2" then b.color = p5.color(0,255,0)
          when "bang3"
            b.color = p5.color(0,0,255)
            b.loc.y += 50


### do not edit below ###

# change canvas / processing sketch size to match resized window, note restarts sketch

$(window).resize ->
  processing.size $(window).width(), $(window).height()

$(document).ready ->
  window.canvas = document.getElementById "p5canvas"
  window.processing = new Processing canvas, coffee_draw
