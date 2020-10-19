extends Node2D

onready var phase1_detection = $BarkSalamanderEvent
onready var phase2_givequest = $BarkSalamanderEventPhase2

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if stats.check_bool("GOT_SWIMMING_CERT"):
		barksalamander_detectionzone.queue_free()
		_on_BarkSalamanderEvent_cutscene_starting()
		cutscene_done()
