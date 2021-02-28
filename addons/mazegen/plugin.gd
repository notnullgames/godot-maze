tool
extends EditorPlugin

var dock

func _enter_tree():
	add_custom_type("Maze", "TileMap", preload("maze.gd"), preload("icon.png"))
	dock = preload("res://addons/mazegen/GUI.tscn").instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)

func _exit_tree():
	remove_custom_type("Maze")
	remove_control_from_docks(dock)
	dock.free()
