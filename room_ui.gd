extends Node2D
class_name RoomUI

@onready var room_label = %"Room Label"

func set_text(text: String):
	room_label.text = text
