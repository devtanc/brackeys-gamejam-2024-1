extends Node

@export var width = 5
@export var height = 5
@export var RoomScene:PackedScene

@onready var map_manager = %MapManager

# Called when the node enters the scene tree for the first time.
func _ready():
	map_manager.generate_map(width, height)
	render_map(map_manager)

func render_map(manager: MapManager):
	for row in range(manager.map.rows.size()):
		for col in range(manager.map.rows[row].rooms.size()):
			var room = manager.map.rows[row].rooms[col]
			if room == null:
				continue
			var room_ui = RoomScene.instantiate()
			add_child(room_ui)
			room_ui.global_position.x = col * 300
			room_ui.global_position.y = row * 300
			room_ui.set_text(room.type)
