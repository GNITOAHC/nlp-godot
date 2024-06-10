extends Node

var socket = WebSocketPeer.new()

func _ready():
	print("websocket ready.")
	socket.connect_to_url("ws://localhost:8765")
	
func wait(sec: float) -> void:
	await get_tree().create_timer(sec).timeout
	
func capture(path: String) -> void:
	var img = get_viewport().get_texture().get_image()
	img.save_png(path)

func mock_press(keys: Array) -> void:
	for key in keys:
		Input.action_press(key, 1.0)
	await wait(0.5)
	for key in keys:
		Input.action_release(key) # Throttle
	return

func move(action: String) -> void:
	match action:
		"front": mock_press(["Throttle"])
		"front_right": mock_press(["Throttle", "Steer Right"])
		"front_left": mock_press(["Throttle", "Steer Left"])
	return

func _process(delta):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		#socket.send_text("From godot engine 1")
		while socket.get_available_packet_count():
			socket.send_text("From godot engine 1")
			var cmd = socket.get_packet().get_string_from_ascii()
			print(cmd)
			move(cmd)
			capture("C:/Users/chaot/Downloads/image.png")
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
