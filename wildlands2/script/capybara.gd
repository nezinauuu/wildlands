extends CharacterBody2D

var speed = 30
var current_state = IDLE

var dir = Vector2.RIGHT
var is_roaming = true
var start_pos

enum{
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready() -> void:
	randomize()
	start_pos = position
	

func _process(delta: float) -> void:
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2:
		if dir.x == -1:
			$AnimatedSprite2D.play("walk-L")
		if dir.x == 1:
			$AnimatedSprite2D.play("walk-R")
		if dir.y == -1:
			$AnimatedSprite2D.play("walk-UP")
		if dir.y == 1:
			$AnimatedSprite2D.play("walk-DOWN")
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)

func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	position += dir * speed * delta 
		


func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5,1,1,1.5])
	current_state = choose([IDLE,NEW_DIR, MOVE])
