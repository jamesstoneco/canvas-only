import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.opengl.*;

float t = 0.0;

PeasyCam cam;

void setup() {
  size(400, 400, OPENGL);
  cam = new PeasyCam(this, 500);
}

void draw() {
  lights();
  background(255);
  noStroke();
  fill(200);
  translate(-width/2, 0);
  t += 0.001;
  int offset = 10;
  float shapeSize = 5.0;
  for (int i = 1; i < 10; i++) {
    // ellipse(noise(t+i*offset*0.01)*width, sin(float(frameCount + i*offset)/100)*height/2, shapeSize*i, shapeSize*i);
    float x = noise(t+i*offset*0.01)*width;
    float y = sin(float(frameCount + i*offset)/100)*height/2;
    pushMatrix();
      translate(x,y);
      sphere(shapeSize*i);
    popMatrix();
    
  }
}
