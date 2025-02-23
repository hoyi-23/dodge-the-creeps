extends Node

# 實體化mob場景
@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$DeathSound.play()
	
func new_game():
	score=0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	
# 過多少秒加一分
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

	
# start 倒數計時後，就要開始倒數ScoreTimer 和 MobTimer 
func _on_start_timer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()
	
# 每次 MobTimer timeout後要加入mob 
# 並設定 Mob進入的地點與方向
func _on_mob_timer_timeout():
	# 建立一個mob實體
	var mob = mob_scene.instantiate()
	# 取得 MobSpawnLocation子節點
	var mob_spawn_location = $MobPath/MobSpawnLocation
	# 在 MobPath上隨機找地方
	mob_spawn_location.progress_ratio = randf()
	#mob_spawn_location.rotation 是當前路徑的角度，表示 PathFollow2D 在這個點的朝向。
	# + PI / 2 代表 將敵人的方向轉 90 度，因為通常 Path2D 的方向是沿著曲線方向，而敵人應該是垂直向外移動。
	var direction = mob_spawn_location.rotation + PI / 2
	
	# 讓敵人的位置和mob_spawn_location的位置一樣
	mob.position = mob_spawn_location.position
	# 讓敵人的角度再隨機一些
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# 設定敵人的速度
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# 將敵人加入
	add_child(mob)


func _on_hud_start_game():
	new_game()
