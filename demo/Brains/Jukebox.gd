extends AudioStreamPlayer

func play_song(song):
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
