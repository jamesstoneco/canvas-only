# set the scene size
WIDTH = $(window).width()
HEIGHT = $(window).height()

# set some camera attribut  es
VIEW_ANGLE = 45
ASPECT = WIDTH / HEIGHT
NEAR = 0.1
FAR = 10000

# get the DOM element to attach to
# - assume we've got jQuery to hand
$container = $("#container")

# create a WebGL renderer, camera
# and a scene
renderer = new THREE.WebGLRenderer()
camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
scene = new THREE.Scene()

# the camera starts at 0,0,0 so pull it back
camera.position.z = 300

# start the renderer
renderer.setSize WIDTH, HEIGHT

# attach the render-supplied DOM element
$container.append renderer.domElement

# create the sphere's material
sphereMaterial = new THREE.MeshLambertMaterial(color: 0xCC0000)

# set up the sphere vars
radius = WIDTH / 20
segments = 32
rings = 32

# create a new mesh with sphere geometry -
# we will cover the sphereMaterial next!
sphere = new THREE.Mesh(new THREE.SphereGeometry(radius, segments, rings), sphereMaterial)

# add the sphere to the scene
scene.add sphere

# and the camera
scene.add camera

# create a point light
pointLight = new THREE.PointLight(0xFFFFFF)

# set its position
pointLight.position.x = 10
pointLight.position.y = 50
pointLight.position.z = 130

# add to the scene
scene.add pointLight

# draw!
renderer.render scene, camera
