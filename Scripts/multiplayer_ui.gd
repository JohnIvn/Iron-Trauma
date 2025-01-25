extends Control

var multiplayer_peer = ENetMultiplayerPeer.new()
var IP_ADDRESS = "192.168.2.2"

var PORT = 3000
var MAX_CLIENTS = 4

func _on_start_pressed():
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	print("Server Peer ID: ", multiplayer.multiplayer_peer.get_peer_id())
	pass 
	



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/Main Menu/menu.tscn")
