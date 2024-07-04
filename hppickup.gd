extends Area2D

# Define variables
@export var float_amplitude = 5.0  # The height of the float
@export var float_speed = 0.7       # The speed of the float

# Store the original position
var original_y = 0.0
var d = 0.0
var pos 
var speed = 10
func _ready():
	pos = self.global_position
	original_y = position.y

func _process(delta):
	if $"../../player":
		pos -= (self.global_position-$"../../player".global_position).normalized() * speed*delta
		position.x = pos.x
		original_y = pos.y
	d += delta
	var new_y = original_y + float_amplitude * sin(2 * PI * float_speed * d)
	position.y = new_y


func _on_body_entered(body):
	if body == $"../../player":
		body.healthpickup()
		queue_free()
		
