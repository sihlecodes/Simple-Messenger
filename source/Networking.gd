extends Node

const PORT: = 9823
var users: = {1: "Server"}

func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	create_or_join()

func create_or_join():
	var peer: = ENetMultiplayerPeer.new()

	if create_session(peer) != OK:
		join_session(peer)

	multiplayer.set_multiplayer_peer(peer)

func create_session(peer: ENetMultiplayerPeer):
	var error: = peer.create_server(PORT)

	if not multiplayer.peer_connected.is_connected(_on_user_connected):
		multiplayer.peer_connected.connect(_on_user_connected)

	if not multiplayer.peer_disconnected.is_connected(_on_user_disconnected):
		multiplayer.peer_disconnected.connect(_on_user_disconnected)

	if error == OK:
		print("Server running at localhost:", PORT)

	return error

func join_session(peer: ENetMultiplayerPeer):
	peer.create_client("localhost", PORT)

@rpc("any_peer", "call_local")
func serve_message(message: String):
	var id: = multiplayer.get_remote_sender_id()
	var username: String = users[id]

	recieve_message.rpc(id, username, message)

@rpc("any_peer", "call_local")
func recieve_message(sender_id: int, sender_name: String, message: String):
	var unique_id: = multiplayer.get_unique_id()

	if sender_id == unique_id:
		sender_name = "[color=tomato]You[/color]"
	else:
		sender_name = "[color=cornflowerblue]%s[/color]" % sender_name

	message = "%s: %s" % [sender_name, message]
	%messages.text += ("\n" + message) if %messages.text else message

@rpc("call_local")
func add_user(id: int):
	users[id] = "User%d" % randi_range(1000, 10000)

func _on_user_connected(id: int):
	if is_multiplayer_authority():
		add_user.rpc_id(1, id)

func _on_user_disconnected(id: int):
	print(id, " this nigga just disconnected!")

func _on_connected_fail():
	print("Connection failed...")

func _on_server_disconnected():
	create_or_join()
