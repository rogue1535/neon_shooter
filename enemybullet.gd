extends Area2D
@export var speed = 230
var direct = Vector2(0,0)
var velocity = Vector2.ZERO
var live = true
var timer = 5
var start = 0.0
func _ready():
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if start>= timer:
		queue_free()
	#if live:
	position += velocity * delta * speed
	if !live:
		velocity = lerp(velocity,Vector2.ZERO,delta * 20)
		


func _on_body_entered(body):
	if body.has_method('handle_ehit'):
		body.handle_ehit(velocity.normalized(),20,15)
		queue_free()
