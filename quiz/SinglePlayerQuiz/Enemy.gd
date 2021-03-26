extends Control


# Declare member variables here. Examples:
export(int) var hp = 10;
export(String) var displayedName;
export(Texture) var image;


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Name").set_text(name);
	get_node("HpValue").set_text(str(hp));
	get_node("avartar").set_texture(image);
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
