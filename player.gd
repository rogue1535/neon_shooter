extends CharacterBody2D
@export var recoil = 0.08
@export var offs = 40
@export var speed = 150
@export var acc = 7
@export var deacc = 2
var hp := 100.0
@export var bulletPath = preload("res://playerbullet.tscn")
#@onready var gunbarrel = $Node2D/gunbarrel
#@onready var attack_cooldown = "res://attack_cooldown.gd"
@export var can_attack = true 

@export var label : Node
#@onready var animation_play = $hurtanim
var mouse_inside = false
signal time
signal player_bulllet_fired

var attacktimer = 0.00
@export var attackspeed = 0.7
var ats = 0.7

var alive = true

var atkspd = 0
var bulletcount = 0
var dmgmul = 0
var fireef = 0
var freezeef = 0
var elecef = 0

func _ready():
	Global.player = self
 
func _process(delta):
	var dir = Vector2(0,0)
	$"../CanvasLayer/Control/Container/TextureProgressBar".value = int(lerp(float($"../CanvasLayer/Control/Container/TextureProgressBar".value),hp,1.0))
	if alive:
		autofire(delta)
		if label:
			label.text = str(Global.score)
		
		if Input.is_action_pressed("up") :
			dir.y -= 1
		if Input.is_action_pressed("down") :
			dir.y += 1
		if Input.is_action_pressed("left") :
			dir.x -= 1
		if Input.is_action_pressed('right') :
			dir.x +=  1 
		
		pass
	dir = dir.normalized()
	var mouse_pos = get_global_mouse_position()
	$Camera2D.offset.x =offs *(mouse_pos.x - global_position.x) / (get_viewport_rect().size.x/2.0)
	$Camera2D.offset.y =offs *(mouse_pos.y - global_position.y) / (get_viewport_rect().size.y/2.0)
	
	if dir.x != 0 or dir.y != 0:
		velocity.y = lerp(velocity.y, dir.y * speed, delta*acc)#*0.01666666667 / delta
		velocity.x = lerp(velocity.x, dir.x * speed, delta*acc)#*0.01666666667 / delta
	else:
		velocity.y = lerp(velocity.y, 0.0, delta * deacc)
		velocity.x = lerp(velocity.x, 0.0, delta * deacc)
	
	if Input.is_action_just_pressed('shoot') :
		Global.camera.shake(1,100)
	#velocity = velocity.clamp(-speed,speed)
		#velocity+= Vector2.RIGHT * 300
	#clamp(velocity,Vector2(-400,-400),Vector2(400,400))
	#position += velocity * delta
	move_and_slide()
	look_at(get_global_mouse_position())



func _unhandled_input(event:):
	if event.is_action_pressed('shoot') :
		
		shoot()

func shoot():
	var rot =(get_global_mouse_position() - self.global_position).angle() #+ randf_range(-recoil,recoil)
	Global.camera.shake(1,100)
	if bulletcount == 0:
		straightbullet(rot)
		
	if bulletcount == 1:
		var bullets = bulletPath.instantiate()
		$"../bullets".add_child(bullets)
		bullets.global_position = self.global_position +Vector2.RIGHT.rotated(rot+0.2)*30
		bullets.velocity = Vector2.RIGHT.rotated(rot)
		bullets.rotation = rot
		
		var bullets2 = bulletPath.instantiate()
		$"../bullets".add_child(bullets2)
		bullets2.global_position = self.global_position +Vector2.RIGHT.rotated(rot-0.2)*30
		bullets2.velocity = Vector2.RIGHT.rotated(rot)
		bullets2.rotation = rot
		
	if bulletcount ==2:
		straightbullet(rot)
		sidebullets(rot,0.1)

	if bulletcount >=3:
		straightbullet(rot)
		sidebullets(rot,0.2)
		sidebullets(rot,0.4)

func straightbullet(rot):
	var bullets = bulletPath.instantiate()
	$"../bullets".add_child(bullets)
	bullets.global_position = self.global_position +Vector2.RIGHT.rotated(rot)*30
	bullets.velocity = Vector2.RIGHT.rotated(rot)
	bullets.rotation = rot

func sidebullets(rot,ang):
	var bullets1 = bulletPath.instantiate()
	$"../bullets".add_child(bullets1)
	bullets1.global_position = self.global_position +Vector2.RIGHT.rotated(rot+ang)*30
	bullets1.velocity = Vector2.RIGHT.rotated(rot+ang)
	bullets1.rotation = rot+ang

	var bullets2 = bulletPath.instantiate()
	$"../bullets".add_child(bullets2)
	bullets2.global_position = self.global_position +Vector2.RIGHT.rotated(rot-ang)*30
	bullets2.velocity = Vector2.RIGHT.rotated(rot-ang)
	bullets2.rotation = rot-ang


func handle_ehit(dir,push,dmg):
	Global.camera.shake(0.8,600)
	hp -=dmg
	if hp <=0.0:
		hp = 0.0
		$death.play('death')
		alive =false
	Global.hp = hp
	if hp <= 50.0:
		Global.changeprb('health',0.1)
	
	$hurtanim.play('hurt')
	#if velocity.length() <= 400:
	velocity+= dir.normalized() * push
	

func upgradeAtkspeed():
	atkspd += 1
	Global.normalizeprbs()
	$effects.play('atkspd')
	attackspeed *=0.7
	
		

func upgradebulletcount():
	
	bulletcount += 1
	if bulletcount >=3:
		Global.changeprb('bulletcount',0.0)
	attackspeed *= 1.2
	$effects.play('atkspd')


func healthpickup():
	Global.hp = 100.0
	Global.changeprb('health',0.1)
	hp= 100
	


func autofire(delta):
	attacktimer += delta
	if attacktimer >= attackspeed:
		attacktimer = 0
		shoot()


