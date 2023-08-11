extends Node

const PORT: = 9823

var users: Dictionary = {1: "Server"}
var username: String

func smart_connect(signal_: Signal, callback: Callable):
	if not signal_.is_connected(callback):
		signal_.connect(callback)

func create_or_join():
	var peer: = ENetMultiplayerPeer.new()

	if create_session(peer) != OK:
		join_session(peer)

	multiplayer.set_multiplayer_peer(peer)

	if not multiplayer.is_server():
		smart_connect(multiplayer.connected_to_server, _on_connected_to_server)
		smart_connect(multiplayer.connection_failed, _on_connected_fail)
		smart_connect(multiplayer.server_disconnected, _on_server_disconnected)
		return


	smart_connect(multiplayer.peer_disconnected, _on_user_disconnected)

func create_session(peer: ENetMultiplayerPeer):
	var error: = peer.create_server(PORT)

	if error == OK:
		print("Server running at localhost:", PORT)

	return error

func join_session(peer: ENetMultiplayerPeer):
	peer.create_client("localhost", PORT)

func serve_message(message):
	_serve_message.rpc_id(1, message)

@rpc("any_peer", "call_local")
func _serve_message(message: String):
	if not message:
		return

	var id: = multiplayer.get_remote_sender_id()
	var username: String = users[id]

	recieve_message.rpc(id, username, message)

@rpc("any_peer", "call_local")
func recieve_message(sender_id: int, sender_name: String, message: String):
	if sender_id == multiplayer.get_unique_id():
		sender_name = "[color=tomato]You[/color]"
	else:
		sender_name = "[color=cornflowerblue]%s[/color]" % sender_name

	message = "%s: %s" % [sender_name, message]
	%messages.text += ("\n" + message) if %messages.text else message

func add_user(id: int):
	users[id] = "User%d" % randi_range(1000, 10000)

func remove_user(id: int):
	users.erase(id)

func _on_user_connected(id: int):
	add_user(id)

func _on_user_disconnected(id: int):
	remove_user(id)

func _on_connected_fail():
	print("Connection failed...")

func _on_server_disconnected():
	create_or_join()
