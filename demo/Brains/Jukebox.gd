extends AudioStreamPlayer

func play_song(song):
	self.volume_db = 0
	var loaded_song = load(song)
	if playing:
		if stream == loaded_song:
			return
	stream = loaded_song
	play()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func stop_it():
	stop()

func free_it(_a, _b, obj):
	obj.queue_free()

func fade_out(length=1.2):
	var tween = Tween.new()
	self.add_child(tween)
	tween.connect("tween_completed", self, "free_it", [tween])
	tween.interpolate_property(self, "volume_db", self.volume_db, -80, length)
	tween.start()
