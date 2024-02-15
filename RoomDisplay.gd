extends Node2D

var manager: MapManager
var spacing: int = 1

@export var initialPosition: Vector2 = Vector2(140, 110)
	
func _draw():
	if manager == null: return
	var rooms = manager.map.get_all_rooms()
	for room in rooms:
		for i in room.connected_rooms.size():
			var curr_conn = room.connected_rooms[i]
			var start_offset = Vector2.from_angle(((2 * PI) / 5) * i) * 50
			var start = initialPosition + Vector2(room.col * spacing, room.row * spacing)
			var end = initialPosition + Vector2(curr_conn.room.col * spacing, curr_conn.room.row * spacing)
			var color = Color.DEEP_SKY_BLUE if curr_conn.direction == 2 else Color.CRIMSON
			draw_line(start + start_offset, end, color, 5)
			draw_circle(start + start_offset, 10, color)
	pass

func set_map(new_manager: MapManager, new_spacing: int = 1):
	manager = new_manager
	spacing = new_spacing
	queue_redraw()
