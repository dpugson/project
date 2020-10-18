extends YSort

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var animation = $AnimationPlayer
onready var pericles_sprite = $Node2D/Pericles/AnimatedSprite
onready var gilby_sprite = $Node2D/Gilby/AnimatedSprite
onready var stats = PlayerStats

const green_angry = "res://sprites/cavestuff/salamanders/green_react0.png"
const green_shifty = "res://sprites/cavestuff/salamanders/green_react1.png"
const pink_chuffed = "res://sprites/cavestuff/salamanders/pink_react0.png"
const pink_thinking = "res://sprites/cavestuff/salamanders/pict_react1.png"

signal done

func _ready():
	if not stats.check_bool(GOT_SWIMMING_CERT):
		animation.play("Appear")
	else:
		animation.play("BackOff")

const GILBY_PITCH = 1.5


var dialogue = {
	"begin" : [
		"TEXT", "What's with all this racket????", 0.01, "perry1", null,
		green_angry, GILBY_PITCH
	],
	"perry1" : [
		"TEXT", "Gilby!!! You see that?? I think that's one of those poopies!!",
		0.02, "gilby2", null, pink_chuffed
	],
	"gilby2" : [
		"TEXT", "A what, now?", 0.01, "perry2", null, green_shifty, GILBY_PITCH
	],
	"perry2" : [
		"TEXT", "A poopy, you know? Like on the nature channel!",
		0.02, "gilby3", null, pink_chuffed
	],
	"gilby3" : [
		"TEXT", "Uhh...", 0.01, "gilby4", null, green_shifty, GILBY_PITCH
	],
	"gilby4" : [
		"TEXT", "Well, whatever it is, it's making a racket!", 0.01, "perry3", null, green_angry, GILBY_PITCH
	],
	"perry3" : [
		"TEXT", "I'm gonna go talk to it.", 0.01, "gilby5", null, pink_thinking
	],
	"gilby5" : [
		"ACTION", "Whhaa- don't talk to it!!!!", 0.01, null, [self, "perry_swim_over"], green_angry, GILBY_PITCH
	],
}

func start_encounter():
	DialogueHelper.showDialogue(self, dialogue, true)
	
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
		[["BARK", "barked"], ["Salutations!", "wellmet"]], null, pink_chuffed
	],
	"barked" : [
		"TEXT", "I told you not to talk it!!!\nIt's obviously a killer!!!", 0.01,
		"cute", null, green_angry, GILBY_PITCH
	],
	"wellmet" : [
		"ACTION", "Salutations!!!", 0.01,
		"cute2", null, pink_chuffed
	],
	"cute" : [
		"ACTION", "It's a cutie!!!", 0.03, "whatswrong0", [self, "perry_turn", "down"], pink_thinking
	],
	"cute2" : [
		"ACTION", "What a cutie!!!\nAnd what an impressive vocabulary!!!", 0.03,
		"whatswrong0", [self, "perry_turn", "down"], pink_thinking
	],
	"whatswrong0" : [
		"ACTION", "I think something must be wrong...\nI'm gonna ask if he's ok.", 0.03,
		"whatswrong", [self, "perry_turn", "down"], pink_chuffed
	],
	"whatswrong" : [
		"ACTION", "Hey, little guy! What's wrong?", 0.03, 
		[
			["Nothing...", "nothing"],
			["Something...", "something"],
		]
		, [self, "perry_turn", "up"], pink_chuffed
	],
	"something" : [
		"ACTION", "Oh my goodness!!! That's terrible!!!!!", 0.03, null
		, [self, "gilby_swim_over_sweet"], pink_thinking
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
		"help", [self, "perry_turn", "left"], pink_chuffed
	],
	"help": [
		"TEXT", "Hey, little poopy!! We're here to help!", 0.03,
		"help2", [self, "perry_turn", "up"], pink_thinking
	],
	"help2": [
		"TEXT", "Tell us what's the matter!", 0.03,
		[
			["*sniff*", "lost"],
			["*bark*", "lost"]
		],
		[self, "gilby_turn", "up"], pink_thinking
	],
	"lost": [
		"TEXT", "You're lost, and you wanna go home?", 0.03,
		[
			["*woof*", "yup"],
			["*wheeze*", "yup"]
		],
		null, pink_chuffed
	],
	"yup": [
		"TEXT", "Wow...\nGilby, this poor poopy is lost!!!", 0.03,
		"yup2",
		[self, "perry_turn", "left"], pink_thinking
	],
	"yup2": [
		"TEXT", "We need to help him, Perry!\nIt's our Fish Person duty!", 0.03,
		"ask",
		[self, "gilby_turn", "right"], green_shifty, GILBY_PITCH
	],
	"ask": [
		"TEXT", "Well, where's home, little buddy??", 0.03,
		[["*point up*", "up_there"]],
		[self, "perry_turn", "up"], pink_chuffed	
	],
	"up_there": [
		"TEXT", "You fell, huh? I see...", 0.03,
		"onlyway",
		[self, "gilby_turn", "up"], pink_thinking
	],
	"onlyway": [
		"TEXT", "Well, the best way out of these caverns is to swim!", 0.03,
		[["...", "swim"]],
		null, pink_thinking
	],
	"swim": [
		"TEXT", "You do know how to swim, right?", 0.02,
		[["ummmmm....", "notknow"], ["uhhh....", "notknow"]],
		null, pink_chuffed
	],
	"notknow": [
		"TEXT", "W-whaa???!!!", 0.02,
		"notknow2",
		null, pink_chuffed
	],
	"notknow2": [
		"TEXT", "Gilby, this poopy doesn't know how to swim!!!", 0.02,
		"what",
		[self, "perry_turn", "left"], pink_thinking
	],
	"what": [
		"TEXT", "What!!!", 0.02,
		"isaid",
		[self, "gilby_turn", "right"], green_angry, GILBY_PITCH
	],
	"isaid": [
		"TEXT", "I said, the poopy can't swim!", 0.02,
		"iheard",
		null, pink_thinking
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
		null, pink_thinking
	],
	"greatidea2": [
		"TEXT", "You're one lucky poopy! Our Gilby here is a great teacher!", 0.02,
		"teach2",
		[self, "perry_turn", "up"], pink_chuffed
	],
}

var teaching  = {
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
		null, pink_thinking
	],
	"knowhownow": [
		"TEXT", "So now you know how to swim!", 0.02,
		"givecertificate",
		null, green_shifty, GILBY_PITCH
	],
	"givecertificate": [
		"TEXT", "Give him the certificate, Gilby!", 0.02,
		"actually_give_cert",
		null, pink_thinking
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
		[self, "encounter_over"], pink_thinking
	],
}

func give_cert():
	stats.inventory_add('swimming_cert')

func play_fun_sound():
	pass
	
const GOT_SWIMMING_CERT = "GOT_SWIMMING_CERT"

func encounter_over():
	stats.world_state[GOT_SWIMMING_CERT] = true
	animation.play("BackOff")
	emit_signal("done")
