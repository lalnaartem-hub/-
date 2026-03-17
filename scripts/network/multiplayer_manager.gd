extends Node
class_name MultiplayerManager

signal host_started(port: int)
signal host_failed(error_code: int)
signal client_connected(address: String, port: int)
signal client_failed(error_code: int)

@export var server_port: int = 27015

func start_host() -> bool:
	var peer := ENetMultiplayerPeer.new()
	var error_code := peer.create_server(server_port)
	if error_code != OK:
		host_failed.emit(error_code)
		push_error("Failed to start host on port %d. Error: %d" % [server_port, error_code])
		return false
	multiplayer.multiplayer_peer = peer
	host_started.emit(server_port)
	return true

func join_server(ip_address: String) -> bool:
	var peer := ENetMultiplayerPeer.new()
	var error_code := peer.create_client(ip_address, server_port)
	if error_code != OK:
		client_failed.emit(error_code)
		push_error("Failed to connect to %s:%d. Error: %d" % [ip_address, server_port, error_code])
		return false
	multiplayer.multiplayer_peer = peer
	client_connected.emit(ip_address, server_port)
	return true

func shutdown_network() -> void:
	multiplayer.multiplayer_peer = null
