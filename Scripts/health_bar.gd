extends Node2D

@onready var health_bar: Sprite2D = $Health

@onready var default_width = health_bar.region_rect.size.x 
@onready var default_height = health_bar.region_rect.size.y

func update_health(new_health: int) -> void:
#	Resize the bar for the health,.... slime has 100 health so 10 dmg is 10 percent of 18 width = 1.8. so - 1.8 per 10 dmg?
	var new_width = (new_health / 100.00) * default_width
	health_bar.region_rect = Rect2(0,0, new_width, default_height)
	
	if new_width <= 0:
		queue_free()
	
