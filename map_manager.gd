extends Node
class_name MapManager

@export var room_chance: float = 0.75

class Row:
	var rooms: Array[Room] = []
	
	func _init(count: int, room_chance: float):
		for i in count:
			var chance = randf()
			if chance < room_chance:
				rooms.append(Room.new())
			else:
				rooms.append(null)
		pass

class Map:
	var rows: Array[Row] = []
	
	func _init(width: int, height: int, room_chance: float):
		for i in height:
			rows.append(Row.new(width, room_chance))
		pass

var map: Map

func generate_map(width: int, height: int):
	# for each width & height, is there a room?
		# minimum of (w * h) * 0.75 rooms?
	# for each room, how many connected rooms (1-5) (2-3 most common)
	# give each room a type: shop, gold, good, bad, none
	var map = Map.new(width, height, room_chance)
	# make list of rooms with # of connections
	# pick random room, connect to any other random room
		# decrease both room's available connections
		# is connection one-way?
	# give each room a type: shop, gold, good, bad, vs
	# of rooms w/o type:
		# add shadow realm (3+ connections)
		# add end
			# 1 connection
		# add start
			# 3+ connections
			# 3+ connections away from end (start @ end, count away, remove ineligible rooms)
	pass
