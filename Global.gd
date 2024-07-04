extends Node2D

var camera : Camera2D

var player : CharacterBody2D

var attackspeedlevel = 0
var bulletcountlevel = 0
var hp 
var score = 0
@onready var atkspeed = preload("res://atk_speed.tscn")
@onready var bulletcount = preload("res://bullet_count.tscn")
@onready var healthpick = preload("res://hppick.tscn")
var upgrades
# Called when the node enters the scene tree for the first time.
func _ready():
	upgrades = [{'name':'attackspeed','scene': 1,'prb':0.5}
	,{'name':'bulletcount','scene': 2,'prb':0.4}
	,{'name':'health','scene':3,'prb':0.1}]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func normalizeprbs():
	var total = 0.0
	for upgrade in upgrades:
		total += upgrade.prb
	
	for upgrade in upgrades:
		if upgrade.prb != 0:
			upgrade.prb /= total





func changeprb(prbname,newprb):
	for upgrade in upgrades:
		if upgrade.name == prbname:
			upgrade.prb = newprb
	normalizeprbs()
