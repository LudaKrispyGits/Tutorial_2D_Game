extends CharacterBody2D


const SPEED: int = 100
var target = null
var is_alive: bool = true
var health: int = 60
const knockback_force: int = 70
var defeats: int = 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var collision_shape_2d: CollisionShape2D
@onready var health_bar: Node2D = $HealthBar

func _physics_process(delta: float) -> void:
	if is_alive and target:
		_attack(delta)
	move_and_slide()

func _attack(delta: float) -> void:
	var direction = (target.position - position).normalized()
	animated_sprite_2d.play("Attack")
	position += direction * SPEED * delta
	
func take_damage(damage: int,attacker_position: Vector2) -> void:
	if health > 0:
		health -= damage
		health_bar.update_health(health)
	#	Knockback
		var knockback_direction = (position - attacker_position).normalized()
		var target_position = position + knockback_direction * knockback_force
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position", target_position, 0.4)
	if health <= 0 and is_alive:
		_die()
		print("Slime Died")
		defeats += 1
	
func _die() -> void:
	is_alive = false
	animated_sprite_2d.play("Death")

	$CollisionShape2D.set_deferred("disabled", true)
	$Sight/CollisionShape2D.set_deferred("disabled",true)

	
func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == "Player" and is_alive:
		target = body
		print('Player Here')
		
	pass # Replace with function body.

func _on_sight_body_exited(body: Node2D) -> void:
	if body.name == "Player" and is_alive:
		target = null
		animated_sprite_2d.play("Idle")


	pass # Replace with function body.
