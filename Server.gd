extends Node

const PORT: = 9823

func _ready() -> void:
	var peer: = ENetMultiplayerPeer.new()
	peer.create_server(PORT)

	multiplayer.multiplayer_peer = peer
	print_once_per_client.rpc()

@rpc
func print_once_per_client():
	print("I will be printed to the console once per each connected client.")
