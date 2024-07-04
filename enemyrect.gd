extends CharacterBody2D
@export var speed = 5
var dist 
var hp = 5
var recoil = 0.08
@onready var player :=  $'../../player'
var direction = Vector2.ZERO

@onready var bulletsp := $"../../bullets"
@export var bulletPath = preload("res://enemybullet.tscn")

var alive = true
var attacktimer = 0.00
@export var attackspeed = 1.5
#var xp = preload("res://xp.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"../../player":
		direction = ($"../../player".global_position - self.global_position).normalized()
		velocity = lerp(velocity,direction * speed,delta*5)
		move_and_slide()
		$Polygon2D/Polygon2D/canon.rotation = lerp_angle($Polygon2D/Polygon2D/canon.rotation,direction.angle(),delta*4)
		dist = abs((self.global_position - $"../../player".global_position)).length()
		if alive:
			autofire(delta)


func handle_hit(dir,push,dmg):
	hp -= dmg
	if hp <= 0:
		alive = false
		var rando = randf()
		if rando < 0.4:
			$"../../pickups".choose_levelup(self.global_position)
		Global.score +=2
		$AnimationPlayer.play('death')
	else:
		$AnimationPlayer.play('hit')
		velocity += dir.normalized() * push


func autofire(delta):
	attacktimer += delta
	if attacktimer >= attackspeed:
		attacktimer = 0
		shoot()

func _on_hit_body_entered(body):
	if body.has_method('handle_ehit'):
		body.handle_ehit(direction,300,10)


func shoot():
	var bullets = bulletPath.instantiate()
	var rot =$Polygon2D/Polygon2D/canon.rotation #+ randf_range(-recoil,recoil)
	bulletsp.add_child(bullets)
	bullets.global_position = $Polygon2D/Polygon2D/canon.global_position +Vector2.RIGHT.rotated(rot) * 30 
	bullets.velocity = Vector2.RIGHT.rotated(rot)
	bullets.rotation = rot
	
	
