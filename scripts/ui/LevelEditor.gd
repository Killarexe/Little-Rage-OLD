extends Node2D

const TILES: Array = [
	Vector2(1, 1),
	Vector2(3, 3),
	Vector2(0, 4),
	Vector2(0, 6),
	Vector2(1, 5),
	Vector2(1, 8),
	Vector2(6, 9),
	Vector2(4, 9),
	Vector2(4, 3),
	Vector2(2, 6),
	Vector2(4, 5),
	Vector2(4, 6),
	Vector2(6, 5),
	Vector2(6, 7),
	Vector2(6, 3)
]

@onready var camera: Camera2D = $Camera2D
@onready var level: Node2D = $EditorLevel

var player
var tile_texture: Texture2D
var mouse_pos: Vector2
var tile_pos: Vector2
var current_tile: int
var is_panning: bool
var can_place: bool

func _ready():
	tile_texture = load("res://textures/Tiles.png")
	Global.editor_playing = true
	is_panning = false
	current_tile = -1
	can_place = true
	camera.position = Vector2(205, 850)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera.zoom -= Vector2(0.1, 0.1)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera.zoom += Vector2(0.1, 0.1)
	if event is InputEventMouseMotion:
		print("Motion..")
		if is_panning:
			camera.global_position -= event.relative * camera.zoom * 1000

func _process(delta):
	if OS.get_name() != "Android" || OS.get_name() != "HTML5":
		mouse_pos = camera.get_global_mouse_position()
		is_panning = Input.is_action_pressed("mouse_middle")
		if current_tile >= 0:
			tile_pos = floor(mouse_pos / 16)
			if can_place:
				if Input.is_action_pressed("mouse_left") :
					set_tile()
				elif Input.is_action_pressed("mouse_right"):
					level.remove_tile_and_update(tile_pos)
		queue_redraw()

func set_tile():
	if current_tile == 0:
		level.change_tile_and_update(tile_pos, TILES[current_tile])
	else:
		if current_tile == 9:
			level.change_tile(tile_pos + Vector2(0, 1), Vector2(2, 7))
		level.change_tile(tile_pos, TILES[current_tile])

func _draw():
	if current_tile >= 0 && can_place:
		var offset_x: int = TILES[current_tile].x
		var offset_y: int = TILES[current_tile].y
		draw_texture_rect_region(tile_texture, Rect2(tile_pos * 16, Vector2(16, 16)), Rect2(16 * offset_x, 16 * offset_y, 16, 16))

func _on_item_list_item_selected(index: int):
	current_tile = index - 2
	print(current_tile)

func _on_mouse_entered():
	can_place = false

func _on_mouse_exited():
	can_place = true

func _on_play_button_pressed():
	player = get_node("EditorLevel/Player")
	if Global.editor_playing:
		player.global_position = Vector2(205, 835)
	Global.editor_playing = !Global.editor_playing
	camera.enabled = Global.editor_playing
	player.test_play(!Global.editor_playing)
