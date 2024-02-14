extends Node
class_name MapManager

@export var room_chance: float = 0.75
@export var one_way_chance: float = 0.8

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
	var start_room: Room
	
	func _init(width: int, height: int, room_chance: float):
		for i in height:
			rows.append(Row.new(width, room_chance))
		pass

	func get_all_rooms() -> Array[Room]:
		var rooms: Array[Room] = []
		for row in rows:
			rooms.append_array(row.rooms.filter(func(room): return room != null))
		return rooms
	
	func set_start_room(room):
		room.set_type("start")
		start_room = room

var map: Map

func generate_map(width: int, height: int):
	# for each width & height, is there a room?
		# minimum of (w * h) * 0.75 rooms?
	# for each room, how many connected rooms (1-5) (2-3 most common)
	# give each room a type: shop, gold, good, bad, none
	map = Map.new(width, height, room_chance)
	# make list of rooms with # of connections
	var rooms: Array[Room] = map.get_all_rooms()
	
	while rooms.size() > 1:
		# pick random room to connect to any other random room
		var safesize = rooms.size() - 1
		var room1 = rooms[randi_range(0, safesize)]
		var room2 = rooms[randi_range(0, safesize)]
		while room1 == room2:
			room2 = rooms[randi_range(0, safesize)]
		# is connection one-way?
		#TODO: Do I even need the direction?
		var direction = 1 if randf() < one_way_chance else 2
		# make connection
		var remaining_connections_1 = room1.add_connection(room2, direction)
		if remaining_connections_1 <= 0:
			rooms.erase(room1)
		if direction == 2:
			var remaining_connections_2 = room2.add_connection(room1, direction)
			if remaining_connections_2 <= 0:
				rooms.erase(room2)
	
	# of rooms w/o type:
	rooms = map.get_all_rooms()
	var nonerooms = rooms.filter(func(room): return room.type == "none")
	if nonerooms.size() < 2:
		nonerooms.append_array(rooms)
	# add shadow realm (3+ connections)
	var possible_shadow_rooms = nonerooms.filter(func(room): return room.connected_rooms.size() >= 3)
	if possible_shadow_rooms.size() == 0:
		possible_shadow_rooms = nonerooms.filter(func(room): return room.connected_rooms.size() >= 2)
	var shadowrealm = possible_shadow_rooms[0]
	shadowrealm.set_type("shadow")
	# make all connections one-way towards the shadow realm
	for conn in shadowrealm.connected_rooms:
		conn.direction = 1
	shadowrealm.connected_rooms.clear()
	rooms.erase(shadowrealm)
	
	# add end
	var end_candidates = nonerooms.filter(func(room): return room.connected_rooms.size() == 1)
	if end_candidates.size() == 0:
		end_candidates = nonerooms.filter(func(room): return room.connected_rooms.size() == 2)
	if end_candidates.size() == 0:
		end_candidates = nonerooms.filter(func(room): return room.connected_rooms.size() > 2)
	var endroom = end_candidates[0]
	endroom.set_type("end")
	# ensure there is a 2-way connection to this room
	# can't be a one-way out of it
	endroom.connected_rooms[0].direction = 2
	rooms.erase(endroom)
	
	# add start room
	# 3+ connections away from end
	# start @ end room, traverse away, remove rooms too close
	var connection_count = 0
	var nextroom: Room = endroom
	# any time the next room has 2 connections, there is only one viable room to select
	while nextroom.connected_rooms.size() == 2:
		var lastroom = nextroom
		# ensure all connections are two-way
		for room_conn in nextroom.connected_rooms:
			room_conn.direction = 2
		nextroom = nextroom.connected_rooms.filter(func(room_conn): return room_conn.room != lastroom)[0].room as Room
		connection_count += 1
		rooms.erase(nextroom)
		
	if connection_count >= 3:
		map.set_start_room(nextroom)
		return
	
	for room_conn in nextroom.connected_rooms:
		rooms.erase(room_conn.room)
	
	map.set_start_room(rooms[randi_range(0, rooms.size() - 1)])

