extends AudioStreamPlayer

onready var origin_volume = self.volume_db
var spot = 0

func set_volume(offset):
	self.volume_db = origin_volume + offset

func play_song(song, fade_length=.5, keep_spot=false):
	if keep_spot:
		spot = self.get_playback_position()
	else:
		spot = 0
		
	self.volume_db = origin_volume
	var loaded_song = load(song)
	if playing:
		if stream == loaded_song:
			return
	stream = loaded_song
	if fade_length != 0:
		fade_out(fade_length, "free_it_and_play")
	else:
		play(spot)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func stop_it():
	stop()

func free_it(_a, _b, obj):
	obj.queue_free()

func free_it_and_play(_a, _b, obj):
	obj.queue_free()
	self.volume_db = origin_volume
	play(spot)

func fade_out(length=1.2, followup="free_it"):
	var tween = Tween.new()
	self.add_child(tween)
	tween.connect("tween_completed", self, followup, [tween])
	tween.interpolate_property(self, "volume_db", self.volume_db, -80, length)
	tween.start()
