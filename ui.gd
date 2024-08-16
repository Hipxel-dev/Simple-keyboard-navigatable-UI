extends Node2D

var button = []
var count = []

var index = 0
var selected_button = self
var scroll = 1



func _ready() -> void:
	for i in range(2):
		var button_inst = $button.duplicate()
		button.append(button_inst)
		add_child(button_inst)
		
		button_inst.position.x = -555
		count.append(i * 0.06)
		
	$button.queue_free()
	color_cycle()

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("ui_cancel"):
		var new_button = button[0].duplicate()
		button.append(new_button)
		count.append(0)
		add_child(new_button)
	
	if Input.is_action_pressed("ui_down"):
		if index < button.size() - 1:
			index += 1
		else:
			index = 0
		color_cycle()
	if Input.is_action_pressed("ui_up"):
		if index > 0:
			index -= 1
		else:
			index = button.size() - 1
		color_cycle()
		

		
	if Input.is_action_just_released("mouse_click"):
		for i in range(button.size()):
			if get_global_mouse_position().y > button[i].position.y - 20:
				index = i
				color_cycle()
			
func color_cycle(only_preview = false,prev_index = 0):
	for i in button:
		i.get_node("black").modulate = Color.black
		i.get_node("white").modulate = Color.white
		i.get_node("pink").modulate = Color8(255,0,155,255)
		
	var btn = selected_button

	if not only_preview:
		btn = button[index]
	else:
		btn = button[prev_index]
	
		
	if selected_button != self:
		btn.get_node("black").modulate = Color.white
		btn.get_node("white").modulate = Color.black
		btn.get_node("pink").modulate = Color8(255,0,155,255)
	
var scroll_index = 0
	
func _physics_process(delta: float) -> void:
	$frame.text = str(scroll)
	
	if Input.is_action_pressed("mouse_click"):
		for i in range(button.size()):
			if get_global_mouse_position().y > button[i].position.y - 20 and get_global_mouse_position().y < button[i].position.y + 20:
				button[i].scale -= Vector2.ONE * delta * 5
				color_cycle(true, i)
	
	if index > scroll_index + 4:
		scroll = (index - 4) * -52
		scroll_index += 1
	if index < scroll_index + 1:
		scroll_index -= 1
		scroll = (index - 1) * -52
	
	for i in range(button.size()):
		count[i] -= delta
		if count[i] < 0:
			button[i].position = button[i].position.linear_interpolate($anchor.position + Vector2(0,(i * 52) + scroll),delta * 20)
			button[i].scale = button[i].scale.linear_interpolate(Vector2.ONE * 2,delta * 20)
	
	$ColorRect/scroll.rect_position.y += ( (2 + (float(index ) / float(button.size() - 1)) * 188.00) - $ColorRect/scroll.rect_position.y) * 0.1
	$ColorRect/scroll.rect_position.y = clamp($ColorRect/scroll.rect_position.y, 2, 184.00)
	
	selected_button = button[index]
	selected_button.scale += Vector2.ONE * delta * 2
#	selected_button.position.x += 4
	$select_fx.position = $select_fx.position.linear_interpolate(selected_button.position + Vector2(-185,0),delta * 23)
	
	
#	var speed = sin(OS.get_ticks_msec() * delta * 0.1) * 0.2
	$select_fx.scale.y = abs(sin(OS.get_ticks_msec() * delta * 0.4) * 0.4)

	if Input.is_action_just_pressed("ui_accept"):
		
		for i in range(button.size()):
			button[i].position.x -= 555
			count[i] = i * 0.06
			
			
