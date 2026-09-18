extends CharacterBody2D


const SPEED = 200.0
var last_direction: Vector2 = Vector2.RIGHT
var is_attacking: bool = false
const JUMP_VELOCITY = -400.0
var strenth: int = 20
var hitbox_offset: Vector2
@onready var hitbox: Area2D = $Hitbox

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var swing_sound: AudioStreamPlayer2D = $SwingSound
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D

func _ready() -> void:
#	hitbox offest
	hitbox_offset = hitbox.position

func _physics_process(_delta: float) -> void:
	hitbox.monitoring = false
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()
		
#Skip movement if attacking
	if is_attacking:
		velocity = Vector2.ZERO
		
		return 
		
	
	
	process_movement()
	process_animation()
	move_and_slide()

func process_movement() -> void:
	var direction := Input.get_vector("left", "right","up","down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
		update_hitbox_offset()
	else:
		velocity = Vector2.ZERO

func process_animation() -> void:
	if is_attacking:
		return
	if velocity != Vector2.ZERO:
		play_animation("Walk",last_direction)
	else:
		play_animation("Idle",last_direction)
	

func play_animation(prefix:String, dir: Vector2) -> void:
	
	if dir.x != 0:
		animated_sprite_2d.flip_h = dir.x < 0
		animated_sprite_2d.play(prefix + "_Right")
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + "_Up")
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + "_Down")

func attack() -> void:
	is_attacking = true
	hitbox.monitoring = true
	swing_sound.play()
	play_animation("Attack" , last_direction)
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
	pass # Replace with function body.


#Hitbox offset
func update_hitbox_offset() -> void:
	var x := hitbox_offset.x
	var y := hitbox_offset.y

	match last_direction:
		Vector2.LEFT:
			hitbox.position = Vector2(-x,y)
			collision_shape_2d.shape.size = Vector2(20, 20)
		Vector2.RIGHT:
			hitbox.position = Vector2(x,y)
			collision_shape_2d.shape.size = Vector2(20, 20)
		Vector2.UP:
			hitbox.position = Vector2(y,-x)
			collision_shape_2d.shape.size = Vector2(45, 20)
		Vector2.DOWN:
			hitbox.position = Vector2(-y,x)
			collision_shape_2d.shape.size = Vector2(45, 20)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_attacking and body.name.contains("Slime"):
		body.take_damage(strenth, position)
		print("Slime hit")
