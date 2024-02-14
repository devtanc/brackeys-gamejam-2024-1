extends Node2D
class_name RoomUI

@onready var room_label = %"Room Label"
@onready var position_label = %"Position Label"

func set_text(text: String, row: int, col: int):
	room_label.text = text
	position_label.text = "(%s,%s)" % [row, col]
	
