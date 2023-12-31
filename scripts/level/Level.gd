extends Node2D

@onready var clouds = $Clouds/AnimationPlayer
@onready var clouds_node = $Clouds
@onready var map = $Map

func _ready():
	var playerNode = Global.instanceNodeAtPos(load("res://scenes/prefabs/Player.tscn"), self, Vector2(0, 0))
	map.set_owner(self)
	try_animate_clouds()
	playerNode.start(self.name == "TitleLevel" || self.name.contains("Edit"))

func try_animate_clouds():
	if clouds != null:
		clouds.play("clouds")
		clouds.set_owner(clouds_node)

func get_tile_data(data_name: String, tile_pos: Vector2) -> Variant:
	var data: TileData = map.get_cell_tile_data(2, tile_pos)
	if data != null:
		return data.get_custom_data(data_name)
	return null

func get_all_tile_data(tile_pos: Vector2) -> TileData:
	return map.get_cell_tile_data(2, tile_pos)

func get_tile_id(cell_pos: Vector2i) -> Vector2i:
	return map.get_cell_atlas_coords(2, cell_pos)

func change_tile(tile_pos: Vector2i, tile_id: Vector2i):
	map.set_cell(2, tile_pos, 1, tile_id, 0)

func filter_used_grass_cells() -> Array[Vector2i]:
	var used_grass_cells: Array[Vector2i] = [];
	for cell in map.get_used_cells(2):
		var type: Vector2i = map.get_cell_atlas_coords(2, cell)
		if type.x >=0 && type.x <= 9 && type.y >= 0 && type.y <= 2:
			used_grass_cells.append(cell)
	return used_grass_cells

func change_tile_and_update(tile_pos: Vector2i, tile_id: Vector2i):
	map.set_cell(2, tile_pos, 1, tile_id, 0)
	map.set_cells_terrain_connect(2, filter_used_grass_cells(), 0, 0, false)

func remove_tile_and_update(tile_pos: Vector2i):
	map.erase_cell(2, tile_pos)
	map.set_cells_terrain_connect(2, filter_used_grass_cells(), 0, 0, false)

func replace_tile_by(old_tile_id: Vector2i, new_tile_id: Vector2i):
	for cell_pos in map.get_used_cells_by_id(2, -1, old_tile_id):
		change_tile(cell_pos, new_tile_id)

func turn_tiles(value: bool):
	if !value:
		replace_tile_by(Global.ON_TILE, Global.OFF_TILE)
		
		replace_tile_by(Global.RED_FULL_TILE, Global.RED_EMPTY_TILE)
		replace_tile_by(Global.RED_SPIKE_TILE_DOWN_ON, Global.RED_SPIKE_TILE_DOWN_OFF)
		replace_tile_by(Global.RED_SPIKE_TILE_UP_ON, Global.RED_SPIKE_TILE_UP_OFF)
		replace_tile_by(Global.RED_SPIKE_TILE_LEFT_ON, Global.RED_SPIKE_TILE_LEFT_OFF)
		replace_tile_by(Global.RED_SPIKE_TILE_RIGHT_ON, Global.RED_SPIKE_TILE_RIGHT_OFF)
		
		replace_tile_by(Global.BLUE_EMPTY_TILE, Global.BLUE_FULL_TILE)
		replace_tile_by(Global.BLUE_SPIKE_TILE_DOWN_OFF, Global.BLUE_SPIKE_TILE_DOWN_ON)
		replace_tile_by(Global.BLUE_SPIKE_TILE_UP_OFF, Global.BLUE_SPIKE_TILE_UP_ON)
		replace_tile_by(Global.BLUE_SPIKE_TILE_LEFT_OFF, Global.BLUE_SPIKE_TILE_LEFT_ON)
		replace_tile_by(Global.BLUE_SPIKE_TILE_RIGHT_OFF, Global.BLUE_SPIKE_TILE_RIGHT_ON)
	else:
		replace_tile_by(Global.OFF_TILE, Global.ON_TILE)
		
		replace_tile_by(Global.BLUE_FULL_TILE, Global.BLUE_EMPTY_TILE)
		replace_tile_by(Global.BLUE_SPIKE_TILE_DOWN_ON, Global.BLUE_SPIKE_TILE_DOWN_OFF)
		replace_tile_by(Global.BLUE_SPIKE_TILE_UP_ON, Global.BLUE_SPIKE_TILE_UP_OFF)
		replace_tile_by(Global.BLUE_SPIKE_TILE_LEFT_ON, Global.BLUE_SPIKE_TILE_LEFT_OFF)
		replace_tile_by(Global.BLUE_SPIKE_TILE_RIGHT_ON, Global.BLUE_SPIKE_TILE_RIGHT_OFF)
		
		replace_tile_by(Global.RED_EMPTY_TILE, Global.RED_FULL_TILE)
		replace_tile_by(Global.RED_SPIKE_TILE_DOWN_OFF, Global.RED_SPIKE_TILE_DOWN_ON)
		replace_tile_by(Global.RED_SPIKE_TILE_UP_OFF, Global.RED_SPIKE_TILE_UP_ON)
		replace_tile_by(Global.RED_SPIKE_TILE_LEFT_OFF, Global.RED_SPIKE_TILE_LEFT_ON)
		replace_tile_by(Global.RED_SPIKE_TILE_RIGHT_OFF, Global.RED_SPIKE_TILE_RIGHT_ON)
