extends KinematicBody2D

export var SLOW_DOWN = 5000
export var MAX_SPEED = 200
export var MAX_FLEE_SPEED = 500
export var SPEED_UP = 800
export var KNOCK_BACK = 800
const DestructionEffect = preload("res://effects/EnemyDeathEffect.tscn")
const EffectHelper = preload("res://effects/EffectHelper.gd")

enum {
	IDLE,
	WANDER,
	CHASE,
	FLEE
}

onready var animation = $AnimatedSprite
onready var stats = $Stats
onready var player_detection = $PlayerDetectionZone

var speed = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE

func _ready():
	animation.play()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, delta * SLOW_DOWN)
	knockback = move_and_slide(knockback)
	
	seek_player()
	
	match state:
		IDLE:
			speed = speed.move_toward(Vector2.ZERO, delta * SLOW_DOWN)
		WANDER:
			pass
		FLEE:
			var player = player_detection.last_player_seen
			if player != null:
				var direction = (self.global_position - player.global_position).normalized()
				speed = speed.move_toward(direction * MAX_FLEE_SPEED, SPEED_UP * delta)
			else:
				state = IDLE 
			animation.flip_h = speed.x < 0
		CHASE:
			var player = player_detection.player
			if player != null:
				var direction = (player.global_position - self.global_position).normalized()
				speed = speed.move_toward(direction * MAX_SPEED, SPEED_UP * delta)
			else:
				state = IDLE 
			animation.flip_h = speed.x < 0
			
	speed = move_and_slide(speed)

func seek_player():
	if player_detection.can_see_player():
		if stats.health <= stats.max_health / 2:
			state = FLEE
		else:
			state = CHASE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCK_BACK
	speed = Vector2.ZERO

func _on_Stats_out_of_health():
	EffectHelper.place_effect(self, DestructionEffect)
	queue_free()
#	animation.stop()
#	var timer = Timer.new()
#	timer.set_wait_time(0)
#	timer.connect("timeout", self, "_disappear")
#	add_child(timer)
#	timer.start()
#
#func _disappear():
#	EffectHelper.place_effect(self, DestructionEffect)
#	queue_free()
