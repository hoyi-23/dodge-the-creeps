extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# 隨機在三個動畫中選一個
	# get list of animation name [fly swim walk]
	var mob_type = $AnimatedSprite2D.sprite_frames.get_animation_names()
	# 選擇 0~2 之間的隨機數 (公式 randi() % n) mob_type.size = 3
	$AnimatedSprite2D.play(mob_type[randi() % mob_type.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# 在mob離開Screen外後刪除自己
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
