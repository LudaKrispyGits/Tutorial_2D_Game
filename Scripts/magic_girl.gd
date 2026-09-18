extends CharacterBody2D

const SPEED = 100.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")

	if direction != 0:
		velocity.x = direction * SPEED
		# Play walking animation
		animated_sprite.play("Walk")
		
		if direction > 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
		velocity.x = 0
		animated_sprite.play("Idle")

	move_and_slide()
