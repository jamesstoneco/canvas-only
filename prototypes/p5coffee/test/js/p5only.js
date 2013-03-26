(function() {
	var canvas = document.getElementById('glibcanvas');
	var p5 = new Processing(canvas);

	// let's write a sketch
	var value = 0;
	// Definition for the initial entry point
	p5.setup = function() {
	  p5.size(200,200);
	  // we want to turn off animation, because this is a demo page and it
	  // would use cpu while not being looked at. Only draw on mousemoves
	  p5.noLoop();
	}

	// Draw a "sine wave" using two bezier curves, with an undulating amplitude.
	p5.draw = function() {
	  // partially clear, by overlaying a semi-transparent rect
	  // with background color
	  p5.noStroke();
	  p5.fill(255,75);
	  p5.rect(0,0,200,200);
	  // draw the "sine wave"
	  p5.stroke(100,100,200);
	  p5.noFill();
	  p5.bezier(0,100, 33,100+value, 66,100+value, 100,100);
	  p5.bezier(100,100, 133,100+-value, 166,100+-value, 200,100);
	}

	p5.mouseMoved = function() {
	  value = ( p5.mouseY-100);
	  p5.redraw();
	}

  // Finally, calling setup() will kickstart the sketch
  p5.setup();
}());
