extends Node2D


var level = 1
var spawn_timer = 1.0
var start = 0.0
@onready var player = $"../player"
@onready var rect_enemy = preload("res://enemyrect.tscn")
@onready var triangle_enemy = preload("res://triangle_enemy.tscn")
@export var dict : Array [Resource]

var random_index
var pos
var enem
var enemy
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	start += delta
	if start >= spawn_timer:
		if self.get_child_count() <= level:
			spawn(self.get_child_count())
			start = 0.0
			level +=1
	
	


func spawn(counts):
	for i in level-counts:
		random_index = randi_range(0,dict.size()-1)
		enem = dict[random_index]
		pos = Global.player.position + Vector2(randf_range(get_viewport_rect().size.y,get_viewport_rect().size.x),0).rotated(randi_range(0, 2*PI))
		while pos.y >= 1750 or pos.y <= 0 or pos.x <=0 or pos.x >= 3300:
			pos = Global.player.position + Vector2(randf_range(get_viewport_rect().size.y/2,get_viewport_rect().size.x/2),0).rotated(randi_range(0, 2*PI))
		
		enemy = enem.instantiate()
		enemy.global_position =pos
		add_child(enemy)
		
