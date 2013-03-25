// Create a circle shaped path with its center at the center
// of the view and a radius of 30:
var path = new Path.Circle(view.center, 30);
path.strokeColor = 'black';

function onResize(event) {
    // Whenever the window is resized, recenter the path:
    path.position = view.center;
}