extends Node

const PORT: = 9823

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
func send(message: String):
	%messages.text += ("\n" + message) if %messages.text else message
	print("sending: ", message, " @ ", multiplayer.get_unique_id(), " from ", multiplayer.get_remote_sender_id())

@rpc("call_local")
func add_user(id: int):
	print("server logged: ", id)

func _on_user_connected(id: int):
	if is_multiplayer_authority():
		add_user.rpc_id(1, id)

func _on_user_disconnected(id: int):
	print(id, " this nigga just disconnected!")

func _on_connected_fail():
	print("Connection failed...")

func _on_server_disconnected():
	create_or_join()
