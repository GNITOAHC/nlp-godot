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

func _process(delta):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		#socket.send_text("From godot engine 1")
		while socket.get_available_packet_count():
			socket.send_text("From godot engine 1")
			var cmd = socket.get_packet().get_string_from_ascii()
			print(cmd)
			$"../../Player".move(cmd, 0.1)
			capture("C:/Users/chaot/Downloads/image.png")
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
