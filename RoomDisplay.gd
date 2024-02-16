extends Node2D

var manager: MapManager
var spacing: int = 1

@export var TILE_SIZE: int = 8
@export var TILE_SCALE: int = 2
@export var INIT_POS: Vector2 = Vector2(9 * TILE_SIZE * TILE_SCALE, 8 * TILE_SIZE * TILE_SCALE)

var DOOR_DIST = 6 * TILE_SIZE
var ADJ = (TILE_SIZE / 2) * TILE_SCALE
var OFFSET = DOOR_DIST * TILE_SCALE + ADJ
var DOOR_OFFSETS = [
	Vector2(-OFFSET, -OFFSET),
	Vector2(OFFSET, -OFFSET),
	Vector2(-OFFSET, (OFFSET + ADJ)),
	Vector2(OFFSET, (OFFSET + ADJ)),
]
func _draw():
	if manager == null: return
	var rooms = manager.map.get_all_rooms()
	for room in rooms:
		for i in room.connected_rooms.size():
			var curr_conn = room.connected_rooms[i]
			var start = INIT_POS + Vector2(room.col * spacing + DOOR_OFFSETS[i].x, room.row * spacing + DOOR_OFFSETS[i].y)
			var end = INIT_POS + Vector2(curr_conn.room.col * spacing, curr_conn.room.row * spacing)
			var color = Color.DEEP_SKY_BLUE if curr_conn.direction == 2 else Color.CRIMSON
			draw_line(start, end, color, 5)
			draw_circle(start, 10, color)
	pass

func set_map(new_manager: MapManager, new_spacing: int = 1):
	manager = new_manager
	spacing = new_spacing
	queue_redraw()
