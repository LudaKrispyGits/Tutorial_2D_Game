extends Node2D
@onready var level_root: Node2D = $levelRoot
var lvl:  int = 1
var current_lvl_root: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_lvl_root = get_node("levelRoot")
	_load_level(lvl)
	var exit = current_lvl_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

#lvl management
func _load_level(lvl_number:int) -> void:
	if current_lvl_root:
		current_lvl_root.queue_free()
		
	#change lvl
	var level_path = "res://Scenes/level_%s.tscn" % lvl_number
	current_lvl_root = load(level_path).instantiate() 
	add_child(current_lvl_root)
	current_lvl_root.name = "levelroot"
	
func _setup_level(level_root: Node) -> void:
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	


#Signal Handles
func _on_exit_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.name == "Player":
		lvl += 1
		call_deferred("_load_level", lvl)
