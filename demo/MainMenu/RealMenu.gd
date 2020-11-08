extends CanvasLayer

onready var stats = PlayerStats
onready var animation = $AnimationPlayer
onready var bark_animation = $BarkAnimation
onready var music_player = $MusicAudioStreamPlayer
onready var quit_button = $MainControls/Quit

onready var main_volume = $Settings/Panel/MainVolume
onready var music_volume = $Settings/Panel/MusicVolume
onready var effects_volume = $Settings/Panel/EffectsVolume

var stopped_music = false

func _ready():
	if Jukebox.playing:
		stopped_music = true
		Jukebox.stop()
	bark_animation.play("bark")
	main_volume.value = stats.main_volume
	effects_volume.value = stats.effects_volume
	music_volume.value = stats.music_volume	

func _input(event):
	if event.is_action_pressed("realmenu") or event.is_action_pressed("ui_cancel"):
		self.call_deferred("close")
	
func _on_Quit_pressed():
	Transition.go_to("res://MainMenu/MainMenu.tscn")

func _on_Cancel_pressed():
	close()
	
func close():
	get_tree().paused = false
	if stopped_music:
		Jukebox.play()
	queue_free()
	
func enchild(obj):
	obj.add_child(self)

func _on_MainVolume_value_changed(value):
	stats.main_volume = value
	stats.update_volumes()

func _on_MusicVolume_value_changed(value):
	stats.music_volume = value
	stats.update_volumes()

func _on_EffectsVolume_value_changed(value):
	stats.effects_volume = value
	stats.update_volumes()

func _on_Sound_pressed():
	animation.play("ShowSettings")

func _on_SettingsBackButton_pressed():
	animation.play("default")
