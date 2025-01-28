extends Control

var multiplayer_peer = ENetMultiplayerPeer.new()
var IP_ADDRESS = "192.168.2.2"  

var PORT = 3000
var MAX_CLIENTS = 5

func _on_start_pressed():
	# Start server
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	print(peer)
	pass 
	
func _on_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_client(IP_ADDRESS, PORT)  
	
	if result != OK:
		print("Failed to connect to server")
		return
	
	multiplayer.multiplayer_peer = peer
	print("Connected to server as a client")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/Main Menu/menu.tscn")
