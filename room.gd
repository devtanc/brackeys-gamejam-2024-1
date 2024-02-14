class_name Room
extends Node

class RoomConnection:
	var room: Room = null
	# Should be 1 for 1-way or 2 for 2-way
	var direction: int = 0
	func _init(room_to_connect: Room, conn_direction: int):
		assert(conn_direction == 1 || conn_direction == 2)
		room = room_to_connect
		direction = conn_direction

# Room types
# "none",
# "start",
# "end",
# "good",
# "bad",
# "gold",
# "store",
# "vs",
# "shadow"

var max_connection_count: int = 0
var type: String = "none"
var connected_rooms: Array[RoomConnection] = []

func _init():
	max_connection_count = get_init_max_conn_count()
	type = get_init_room_type()
	
func get_init_max_conn_count():
	var num = randf()
	if num < 0.25:
		return 2
	elif num < 0.50:
		return 3
	elif num < 0.65:
		return 1
	elif num < 0.80:
		return 4
	else:
		return 5

func get_init_room_type() -> String:
	var num = randf()
	if num < 0.3:
		return "none"
	elif num < 0.6:
		if randf() < 0.6:
			return "good"
		else:
			return "bad"
	elif num < 0.8:
		return "gold"
	else:
		return "store"
	
func add_connection(room: Room, direction: int) -> int:
	connected_rooms.append(RoomConnection.new(room, direction))
	return max_connection_count - connected_rooms.size()
