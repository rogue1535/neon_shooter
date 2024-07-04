extends Camera2D

var shake_amount : float = 0
var default_offset : Vector2 = offset
var pos_x : int #number
var pos_y : int
var dmgshake = false
@onready var timer : Timer = $Timer
@onready var tween : Tween = create_tween()

func _ready():
	set_process(true)
	Global.camera = self
	randomize()
	
func _process(delta: float):
	offset += Vector2(randf_range(-1, 1) * shake_amount * delta, randf_range(-1, 1) * shake_amount * delta)
	shake_amount-=delta*shake_amount*2

func shake(time: float, amount: float):
	
	if !dmgshake:
		timer.wait_time = time
		shake_amount = amount
		set_process(true)
		timer.start()
	if amount == 300:
		dmgshake = true

func _on_timer_timeout() -> void:
	if dmgshake:
		dmgshake = !dmgshake
	set_process(false)
	tween.interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
