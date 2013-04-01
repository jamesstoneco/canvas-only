import processing.core.*; 
import processing.xml.*; 

import peasy.test.*; 
import peasy.org.apache.commons.math.*; 
import peasy.*; 
import peasy.org.apache.commons.math.geometry.*; 
import processing.opengl.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class basic_processing_sketch extends PApplet {








float t = 0.0f;

PeasyCam cam;

public void setup() {
  size(400, 400, OPENGL);
  cam = new PeasyCam(this, 500);
}

public void draw() {
  lights();
  background(255);
  noStroke();
  fill(200);
  translate(-width/2, 0);
  t += 0.001f;
  int offset = 10;
  float shapeSize = 5.0f;
  for (int i = 1; i < 10; i++) {
    // ellipse(noise(t+i*offset*0.01)*width, sin(float(frameCount + i*offset)/100)*height/2, shapeSize*i, shapeSize*i);
    float x = noise(t+i*offset*0.01f)*width;
    float y = sin(PApplet.parseFloat(frameCount + i*offset)/100)*height/2;
    pushMatrix();
      translate(x,y);
      sphere(shapeSize*i);
    popMatrix();
    
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--hide-stop", "basic_processing_sketch" });
  }
}
