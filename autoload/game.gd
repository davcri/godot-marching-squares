extends Node

onready var vs = get_viewport().get_visible_rect().size
onready var w = vs.x
onready var h = vs.y


func _ready():
	get_tree().connect("screen_resized", self, "on_screen_resized")
	

func on_screen_resized():
	vs = get_viewport().get_visible_rect().size
	w = vs.x
	h = vs.y
