extends Node2D


@onready var animplayer = $world2openingcutscene/AnimationPlayer
@onready var camera = $world2openingcutscene/Path2D/PathFollow2D/Camera2D
var is_openingcutscene = false

var has_player_entered_area = false
var player = null

var is_pathfollowing = false
var smoke_has_happened = false
var smoke_is_happening = false


func _physics_process(delta: float) -> void:
	if is_openingcutscene:
		var pathfollower = $world2openingcutscene/Path2D/PathFollow2D
		
		if is_pathfollowing:
			if !smoke_is_happening:
				pathfollower.progress_ratio += 0.001
			
			if pathfollower.progress_ratio >= 1:
				cutsceneending()
			
			if !smoke_has_happened and pathfollower.progress_ratio >= 0.95 and !smoke_is_happening:
				smoke_is_happening = true
				toggle_smoke()
				await get_tree().create_timer(1).timeout
				$world2openingcutscene/TileMapFinished.visible = true
				$world2openingcutscene/TileMapUnFinished.visible = false
				toggle_smoke()
				await get_tree().create_timer(0.5).timeout
				smoke_has_happened = true
				smoke_is_happening = false


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		if !has_player_entered_area:
			has_player_entered_area = true
			cutsceneopening()
			
			
func cutsceneopening():
	is_openingcutscene = true
	animplayer.play("cover_fade")
	player.camera.enabled = false
	camera.enabled = true
	is_pathfollowing = true

func cutsceneending():
	is_pathfollowing = false
	is_openingcutscene = false
	camera.enabled = false
	player.camera.enabled = true
	$world2openingcutscene.visible = false
	$world2main.visible = true
	
func toggle_smoke():
	var smoke1 = $world2openingcutscene/SmokeParticles1
	smoke1.emitting = !smoke1.emitting
	
