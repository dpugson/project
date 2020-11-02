extends YSort

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var animation = $AnimationPlayer
onready var gilby = $Node2D/Gilby
onready var perry = $Node2D/Pericles
onready var pericles_sprite = $Node2D/Pericles/AnimatedSprite
onready var gilby_sprite = $Node2D/Gilby/AnimatedSprite
onready var stats = PlayerStats

const green_angry = "res://sprites/cavestuff/salamanders/green_react0.png"
const green_shifty = "res://sprites/cavestuff/salamanders/green_react1.png"
const pink_chuffed = "res://sprites/cavestuff/salamanders/pink_react0.png"
const pink_thinking = "res://sprites/cavestuff/salamanders/pict_react1.png"

signal done

const GOT_SWIMMING_CERT = "GOT_SWIMMING_CERT"

func _ready():
	var got_flippers = stats.inventory_get("flippers") > 0
	var got_cert = stats.check_bool(GOT_SWIMMING_CERT)
	var waiting_for_flippers  = stats.inventory_get("skeleton_key") > 0
	
	if got_cert:
		animation.play("BackOff")
		set_final_dialogue()
	elif got_flippers:
		animation.play("by_shore")
		set_start_swim_dialogue()
	elif waiting_for_flippers:
		animation.play("by_shore")
		set_waiting_for_flippers_dialogue()
	else:
		animation.play("Appear")
		set_final_dialogue()
		# The initial state!

const GILBY_PITCH = 1.5
const PERRY_PITCH = 3

func set_final_dialogue():
	var g_waiting_dialogue = {
		"begin" : [
			"TEXT", "See, what did I tell ya? The secret is LOVE!", 0.01, 
			null, null, green_angry, GILBY_PITCH
		]
	}
	var p_waiting_dialogue = {
		"begin" : [
			"TEXT", "Hi, puppy!!! You're doing great!", 0.01, 
			null, null, pink_chuffed
		],
	}
	gilby.set_dialogue(g_waiting_dialogue)
	perry.set_dialogue(p_waiting_dialogue)

func set_waiting_for_flippers_dialogue():
	var g_waiting_dialogue = {
		"begin" : [
			"TEXT", "Come on! Go get those flippers!", 0.01, 
			null, null, green_angry, GILBY_PITCH
		]
	}
	var p_waiting_dialogue = {
		"begin" : [
			"TEXT", "I'm so excited for you! You're gonna love swimming!!!", 0.01, 
			null, null, pink_chuffed
		],
	}
	gilby.set_dialogue(g_waiting_dialogue)
	perry.set_dialogue(p_waiting_dialogue)

func set_start_swim_dialogue():
	gilby.set_dialogue(teaching)
	perry.set_dialogue(teaching)

var appear_dialogue = {
	"begin" : [
		"TEXT", "What's with all this racket????", 0.01, "perry1", null,
		green_angry, GILBY_PITCH
	],
	"perry1" : [
		"TEXT", "Gilby!!! You see that?? I think that's one of those poopies!!",
		0.02, "gilby2", null, pink_chuffed, PERRY_PITCH
	],
	"gilby2" : [
		"TEXT", "A what, now?", 0.01, "perry2", null, green_shifty, GILBY_PITCH
	],
	"perry2" : [
		"TEXT", "A poopy, you know? Like on the nature channel!",
		0.02, "gilby3", null, pink_chuffed, PERRY_PITCH
	],
	"gilby3" : [
		"TEXT", "Uhh...", 0.01, "gilby4", null, green_shifty, GILBY_PITCH
	],
	"gilby4" : [
		"TEXT", "Well, whatever it is, it's making a racket!", 0.01, "perry3", null, green_angry, GILBY_PITCH
	],
	"perry3" : [
		"TEXT", "I'm gonna go talk to it.", 0.01, "gilby5", null, pink_thinking, PERRY_PITCH
	],
	"gilby5" : [
		"ACTION", "Whhaa- don't talk to it!!!!", 0.01, null, [self, "perry_swim_over"], green_angry, GILBY_PITCH
	],
}

func start_encounter():
	DialogueHelper.showDialogue(self, appear_dialogue, true)
	
func perry_swim_over():
	animation.play("PerrySwimOver")
	
func perry_turn(direction):
	pericles_sprite.animation = direction
	
func gilby_turn(direction):
	gilby_sprite.animation = direction
	
var dialogue2 = {
	"begin" : [
		"TEXT", "Oh great, you're talking to it.",
		0.01, "salutations", null, green_shifty, 2, GILBY_PITCH
	],
	"salutations" : [
		"TEXT", "Hello, poopy! What's up? My name is Pericles!", 0.01, 
		[["BARK", "barked"], ["Salutations!", "wellmet"]], null, pink_chuffed, PERRY_PITCH
	],
	"barked" : [
		"TEXT", "I told you not to talk it!!!\nIt's obviously a killer!!!", 0.01,
		"cute", null, green_angry, GILBY_PITCH
	],
	"wellmet" : [
		"ACTION", "Salutations!!!", 0.01,
		"cute2", null, pink_chuffed, PERRY_PITCH
	],
	"cute" : [
		"ACTION", "It's a cutie!!!", 0.03, "whatswrong0", [self, "perry_turn", "down"], pink_thinking, PERRY_PITCH
	],
	"cute2" : [
		"ACTION", "What a cutie!!!\nAnd what an impressive vocabulary!!!", 0.03,
		"whatswrong0", [self, "perry_turn", "down"], pink_thinking, PERRY_PITCH
	],
	"whatswrong0" : [
		"ACTION", "I think something must be wrong...\nI'm gonna ask if he's ok.", 0.03,
		"whatswrong", [self, "perry_turn", "down"], pink_chuffed, PERRY_PITCH
	],
	"whatswrong" : [
		"ACTION", "Hey, little guy! What's wrong?", 0.03, 
		[
			["Nothing...", "nothing"],
			["Something...", "something"],
		]
		, [self, "perry_turn", "up"], pink_chuffed, PERRY_PITCH
	],
	"something" : [
		"ACTION", "Oh my goodness!!! That's terrible!!!!!", 0.03, null
		, [self, "gilby_swim_over_sweet"], pink_thinking, PERRY_PITCH
	],
	"nothing" : [
		"ACTION", "What? He's lying!! Something's obviously wrong!!!\nAsk again!!", 0.03, 
		"whatswrong"
		, [self, "increment_whats_wrong"], green_shifty, GILBY_PITCH
	],
}

func gilby_swim_over_sweet():
	print("swim!!!")
	dialogue3["begin"] = [
		"ACTION", "THIS POOR POOPY!!!!\nWE NEED TO HELP!!!!!!",
		0.02, "calmdown", null, green_angry, GILBY_PITCH
	]
	animation.play("GilbySwimOver")
	
func gilby_swim_over_angry():
	print("hmmmm")
	dialogue3["begin"] = [
		"ACTION", "YOU TELL ME WHAT'S WRONG\nTHIS INSTANT YOU LITTLE POOP!",
		0.02, "calmdown", null, green_angry, GILBY_PITCH
	]
	animation.play("GilbySwimOver")

var suspicion = 0
func increment_whats_wrong():
	print("suspicion level =", suspicion)
	suspicion += 1
	match suspicion:
		1:
			return
		2:
			dialogue2["nothing"][1] = "What??? You can see in its buggy little eyes-\nLIES!"
		3:
			dialogue2["nothing"][1] ="Come on, Pericles!! Apply some pressure!!!"
		_:
			dialogue2["nothing"][1] ="..."
			dialogue2["whatswrong"] = [
				"ACTION", "................................", 0.01, null, 
				[self, "gilby_swim_over_angry"], green_angry, GILBY_PITCH
			]
	
func dialogue_part2():
	DialogueHelper.showDialogue(self, dialogue2, true)
	
func dialogue_part3():
	DialogueHelper.showDialogue(self, dialogue3, true)
 
var dialogue3 = {
	"begin": [
		"TEXT", "...\n", 0.03, "calmdown"
	],
	"calmdown": [
		"TEXT", "Calm down, Gilby!!!\n", 0.03,
		"help", [self, "perry_turn", "left"], pink_chuffed, PERRY_PITCH
	],
	"help": [
		"TEXT", "Hey, little poopy!! We're here to help!", 0.03,
		"help2", [self, "perry_turn", "up"], pink_thinking, PERRY_PITCH
	],
	"help2": [
		"TEXT", "Tell us what's the matter!", 0.03,
		[
			["*sniff*", "lost"],
			["*bark*", "lost"]
		],
		[self, "gilby_turn", "up"], pink_thinking, PERRY_PITCH
	],
	"lost": [
		"TEXT", "You're lost, and you wanna go home?", 0.03,
		[
			["*woof*", "yup"],
			["*wheeze*", "yup"]
		],
		null, pink_chuffed, PERRY_PITCH
	],
	"yup": [
		"TEXT", "Wow...\nGilby, this poor poopy is lost!!!", 0.03,
		"yup2",
		[self, "perry_turn", "left"], pink_thinking, PERRY_PITCH
	],
	"yup2": [
		"TEXT", "We need to help him, Perry!\nIt's our Fish Person duty!", 0.03,
		"ask",
		[self, "gilby_turn", "right"], green_shifty, GILBY_PITCH
	],
	"ask": [
		"TEXT", "Well, where's home, little buddy??", 0.03,
		[["*point up*", "up_there"]],
		[self, "perry_turn", "up"], pink_chuffed, PERRY_PITCH
	],
	"up_there": [
		"TEXT", "You fell, huh? I see...", 0.03,
		"onlyway",
		[self, "gilby_turn", "up"], pink_thinking, PERRY_PITCH
	],
	"onlyway": [
		"TEXT", "Well, the best way out of these caverns is to swim!", 0.03,
		[["...", "swim"]],
		null, pink_thinking, PERRY_PITCH
	],
	"swim": [
		"TEXT", "You do know how to swim, right?", 0.02,
		[["ummmmm....", "notknow"], ["uhhh....", "notknow"]],
		null, pink_chuffed, PERRY_PITCH
	],
	"notknow": [
		"TEXT", "W-whaa???!!!", 0.02,
		"notknow2",
		null, pink_chuffed, PERRY_PITCH
	],
	"notknow2": [
		"TEXT", "Gilby, this poopy doesn't know how to swim!!!", 0.02,
		"what",
		[self, "perry_turn", "left"], pink_thinking, PERRY_PITCH
	],
	"what": [
		"TEXT", "What!!!", 0.02,
		"isaid",
		[self, "gilby_turn", "right"], green_angry, GILBY_PITCH
	],
	"isaid": [
		"TEXT", "I said, the poopy can't swim!", 0.02,
		"iheard",
		null, pink_thinking, PERRY_PITCH
	],
	"iheard": [
		"TEXT", "I heard you the first time!", 0.02,
		"teach",
		null, green_angry, GILBY_PITCH
	],
	"teach": [
		"TEXT", "We're gonna have to teach the poopy, then!", 0.02,
		"greatidea",
		null, green_shifty, GILBY_PITCH
	],
	"greatidea": [
		"TEXT", "That's a great idea!!!", 0.02,
		"greatidea2",
		null, pink_thinking, PERRY_PITCH
	],
	"greatidea2": [
		"TEXT", "You're one lucky poopy! Our Gilby here is a great teacher!", 0.02,
		"teach2",
		[self, "perry_turn", "up"], pink_chuffed, PERRY_PITCH
	],
	"teach2": [
		"TEXT", "Ok, poopy! Ready to start? Get your flippers on!", 0.02,
		[["ummmmm....", "noflips"], ["uhhh....", "noflips"]],
		[self, "gilby_turn", "up"], green_shifty, GILBY_PITCH
	],
	"noflips": [
		"TEXT", "WHAT!!! You don't have your flippers?", 0.02,
		"noflips2",
		null, green_angry, GILBY_PITCH
	],
	"noflips2": [
		"TEXT", "Perry! This puppy ain't got no flippers!!!", 0.02,
		"noflips3",
		[self, "gilby_turn", "right"], green_shifty, GILBY_PITCH
	],
	"noflips3": [
		"TEXT", "What???", 0.02,
		"noflips4",
		[self, "perry_turn", "left"], pink_thinking, PERRY_PITCH
	],
	"noflips4": [
		"TEXT", "Do we have some spares?", 0.02,
		"whywouldhave", null, pink_thinking, PERRY_PITCH
	],
	"whywouldhave": [
		"TEXT", "We're FISH PEOPLE, why would we have spares?", 0.02,
		"though", null, green_shifty, GILBY_PITCH
	],
	"though" : [
		"TEXT", "Though, you know who would...", 0.02,
		"whowould", null, green_shifty, GILBY_PITCH
	],
	"whowould" : [
		"TEXT", "That guy who lived down here!!!", 0.02,
		"skeleton", null, green_shifty, GILBY_PITCH
	],
	"skeleton" : [
		"TEXT", "Oh!! That guy!!! Oh... Now I'm sad, Gilby!", 0.02,
		"goodrun", null, pink_chuffed, PERRY_PITCH
	],
	"goodrun" : [
		"TEXT", "Eh, he had a good run!!\nAn skelebones don't got feelings, SO....", 0.02,
		"instructions", null, green_shifty, GILBY_PITCH
	],
	"instructions" : [
		"TEXT", "Poopy!!! Before your swimming lessons, you're\ngonna have to do a little chore!", 0.02,
		"quest", [self, "gilby_turn", "up"], green_shifty, GILBY_PITCH
	],
	"quest" : [
		"TEXT", "You're gonna have to go rob the house\nof a weird guy who used to live down here!", 0.02,
		"notrob", [self, "perry_turn", "up"], green_angry, GILBY_PITCH
	],
	"notrob" : [
		"TEXT", "But it ain't robbing, really... More like, recycling!", 0.02,
		"key", null, green_shifty, GILBY_PITCH
	],
	"key" : [
		"TEXT", "Here's a key!", 0.02,
		"get_key", null, green_shifty, GILBY_PITCH
	],
	"get_key" : [
		"TEXT", "YOU RECEIVED A SKELETON KEY", 0.02,
		"door", [self, "give_key"], false
	],
	"door" : [
		"TEXT", "So, just head right up by that door up there!\nIt's a straight shot to the dead guy's house!", 0.02,
		"finish", null, green_shifty, GILBY_PITCH
	],
	"finish" : [
		"TEXT", "Come back here once you've got those flippers\nand we'll get you swimming in no time!", 0.02,
		null, [self, "finish_up"], green_angry, GILBY_PITCH
	],
}

func finish_up():
	set_waiting_for_flippers_dialogue()
	gilby_turn("up")
	perry_turn("up")
	emit_signal("done")

func give_key():
	stats.inventory_add("skeleton_key")

func play_salamander_song():
	Jukebox.play_song("res://tunes/cave/salamanders.wav")

var teaching  = {
	"begin": [
		"TEXT", "Great! You've got them!!!", 0.02,
		"teach1",
		null, #[self, "play_salamander_song"],
		pink_thinking, PERRY_PITCH
	],
	"teach1": [
		"TEXT", "ALRIGHT! LET'S GET STARTED!", 0.02,
		"teach2",
		[self, "gilby_turn", "up"], green_shifty, GILBY_PITCH
	],
	"teach2": [
		"TEXT", "Listen carefully, poopy, cause I'm not going to repeat\nmyself!!", 0.02,
		"teach3",
		[self, "gilby_turn", "up"], green_shifty, GILBY_PITCH
	],
	"teach3": [
		"TEXT", "Swimming is simple, yet profound!!!", 0.02,
		"teach4",
		null, green_angry, GILBY_PITCH
	],
	"teach4": [
		"TEXT", "NO ONE CAN TEACH YOU HOW TO SWIM!!!", 0.02,
		"teach5",
		null, green_angry, GILBY_PITCH
	],
	"teach5": [
		"TEXT", "You have to look deep into your HEART!!!", 0.02,
		"teach6",
		null, green_angry, GILBY_PITCH
	],
	"teach6": [
		"TEXT", "You have to find your TRUE SELF!!!", 0.02,
		"teach7",
		null, green_angry, GILBY_PITCH
	],
	"teach7": [
		"TEXT", "And your true self is LOVE!!!", 0.02,
		"teach8",
		null, green_angry, GILBY_PITCH
	],
	"teach8": [
		"TEXT", "SWIMMING COMES FROM THE HEART!!!", 0.02,
		"teachend",
		null, green_angry, GILBY_PITCH
	],
	"teachend": [
		"TEXT", "Do you understand???!!!", 0.02,
		[["No", "repeat"], ["Yes", "understanded"]],
		null, green_shifty, GILBY_PITCH
	],
	"repeat": [
		"TEXT", "Well... I did say I wouldn't repeat myself,\nBut this is really important!", 0.02,
		"teach3",
		null, green_shifty, GILBY_PITCH
	],
	"understanded": [
		"TEXT", "Wow! You're a quick study!", 0.02,
		"prodigy",
		null, green_shifty, GILBY_PITCH
	],
	"prodigy": [
		"TEXT", "Yeah!!! A prodigy!\nHe had to yell at me for like 5 hours!", 0.02,
		"knowhownow",
		null, pink_thinking, PERRY_PITCH
	],
	"knowhownow": [
		"TEXT", "So now you know how to swim!", 0.02,
		"givecertificate",
		null, green_shifty, GILBY_PITCH
	],
	"givecertificate": [
		"TEXT", "Give him the certificate, Gilby!", 0.02,
		"actually_give_cert",
		null, pink_thinking, PERRY_PITCH
	],
	"actually_give_cert": [
		"TEXT", "Oh yeah, that's right! Of course! Here you go!", 0.02,
		"get_cert",
		[self, "give_cert"], green_shifty, GILBY_PITCH
	],
	"get_cert": [
		"TEXT", "You receive one SWIMMING CERTIFICATION.", 0.02,
		"give_it_a_try",
		[self, "play_fun_sound"], false
	],
	"give_it_a_try": [
		"TEXT", "Come on out, puppy! The water's warm!", 0.02,
		null,
		[self, "encounter_over"], pink_thinking, PERRY_PITCH
	],
}

func give_cert():
	stats.inventory_add('swimming_cert')
	stats.world_state["PSYCHIC_WALL_GONE"] = true

func play_fun_sound():
	pass

func encounter_over():
	stats.world_state[GOT_SWIMMING_CERT] = true
	animation.play("BackOff")
	set_final_dialogue()
	emit_signal("done")
