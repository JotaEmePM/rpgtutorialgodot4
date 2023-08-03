extends CharacterBody2D

@export var speed = 50

var new_direction = Vector2(0, 1)
var animation

var is_attacking = false

func _physics_process(delta):
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if Input.is_action_pressed("ui_sprint"):
		speed = 100
	elif Input.is_action_just_released("ui_sprint"):
		speed = 50
	
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
		
	var movement = speed * direction * delta
	
	
	if !is_attacking:
		move_and_collide(movement)
		player_animations(direction)
		
	if is_attacking and !$AnimatedSprite2D.is_playing():
		is_attacking = false

func player_animations(direction: Vector2):
	if direction != Vector2.ZERO:
		new_direction = direction
		animation = "walk_" + returned_direction(new_direction)
		$AnimatedSprite2D.play(animation)
	else:
		animation = "idle_" + returned_direction(new_direction)
		$AnimatedSprite2D.play(animation)
		
func returned_direction(direction: Vector2):
	var normalized_direction = direction.normalized()
	var default_return = "side"
	
	if normalized_direction.y >= 1:
		return "down"
	elif normalized_direction.y <= -1:
		return "up"
	elif normalized_direction.x >= 1:
		#(right)
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x <= -1:
		#flip the animation for reusability (left)
		$AnimatedSprite2D.flip_h = true
		return "side"
	
	return default_return

func _input(event):
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		var animation = "attack_" + returned_direction(new_direction)
		$AnimatedSprite2D.play(animation)
		


func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
