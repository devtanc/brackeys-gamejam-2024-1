extends Node

@export var width = 5
@export var height = 5
@export var RoomScene:PackedScene
@export var spacing: int = 300

@onready var map_manager = %MapManager
@onready var room_display = %RoomDisplay

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
			var room_sprite = RoomScene.instantiate()
			room_display.add_child(room_sprite)
			room_sprite.global_position.x = col * spacing
			room_sprite.global_position.y = row * spacing
			room_sprite.set_z_index(-1)
			room_sprite.set_text(room.type, room.row, room.col)
	
	room_display.set_map(manager, spacing)
