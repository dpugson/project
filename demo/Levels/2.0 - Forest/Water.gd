tool
extends Sprite

export(NodePath) var cameraPath

var screenHeight;

func _ready():
	screenHeight = ProjectSettings.get_setting("display/window/size/height");

#func _physics_process(_delta):
#	var height: float = self.texture.get_height() * scale.y
#	var camera = get_node(cameraPath)
#	if screenHeight == null:
#		screenHeight = ProjectSettings.get_setting("display/window/size/height");
#	var offset: float = (self.position.y - (height * 0.5)) - (camera.position.y - screenHeight/2)
#	self.material.set_shader_param("offset", 1 - offset/screenHeight)
#	self.material.set_shader_param("height", height/screenHeight)
