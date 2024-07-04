extends CharacterBody2D
@export var speed = 600
var dist 
var hp = 1
var acc = 1.5
@onready var player :=  $'../../player'
@onready var bulletsp := $"../../bullets"
var expath = preload("res://circ_explosion.tscn")
var direction = Vector2.ZERO
#var xp = preload("res://xp.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"../../player":
		direction = ($"../../player".global_position - self.global_position)
		#if velocity.length() >speed:
		velocity.x = lerp(velocity.x,direction.normalized().x * speed,delta*acc) #*clamp(abs(direction.length()),100,500)*0.005*0.4)
		velocity.y = lerp(velocity.y,direction.normalized().y * speed,delta*acc)#*clamp(abs(direction.length()),100,500)*0.005*0.4)
		#velocity += direction.normalized()*delta*speed
		position +=direction.normalized()*0.5
		move_and_slide()
		rotation = lerp_angle(rotation,direction.angle(),delta*acc*3)
		#dist = abs((self.global_position - $"../../player".global_position)).length()
		
		
		

func handle_hit(dir,push,dmg):
	hp -= dmg
	if hp <= 0:
		Global.score += 1
		explode()
	else:
		$AnimationPlayer.play('hit')
		velocity += dir.normalized() * push
	


func _on_hit_body_entered(body):
	if body.has_method('handle_ehit'):
		
		body.handle_ehit(direction,200,25)
		explode()


func explode():
	var rando = randf()
	if rando < 0.3:
		$"../../pickups".choose_levelup(self.global_position)
	
	$AnimationPlayer.play('death')
	var explosion = expath.instantiate()
	bulletsp.add_child(explosion)
	explosion.global_position = self.global_position
