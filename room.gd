class_name Room
extends Node

class RoomConnection:
	var room: Room = null
	var direction: int = 0

enum RoomType {
	None,
	Start,
	End,
	Good,
	Bad,
	Gold,
	Store,
	VS,
	Shadow
}

var max_connection_count: int = 0
var type: RoomType = RoomType.None
var connected_rooms: Array[RoomConnection] = []
# 1,2,3,4,5
func _init():
	max_connection_count = get_init_max_conn_count()
	type = get_init_room_type()
	pass
	
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
	pass

func get_init_room_type():
	var num = randf()
	if num < 0.3:
		return RoomType.None
	elif num < 0.6:
		if randf() < 0.6:
			return RoomType.Good
		else:
			return RoomType.Bad
	elif num < 0.8:
		return RoomType.Gold
	else:
		return RoomType.Store
	pass
