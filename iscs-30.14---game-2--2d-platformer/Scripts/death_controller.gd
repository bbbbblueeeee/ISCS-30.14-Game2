extends Node

signal player_died

func send_player_death_signal():
	player_died.emit()
