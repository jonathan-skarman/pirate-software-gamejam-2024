extends Node2D

@onready var tile_map = $"../TileMap"
@onready var animated_sprite_2d_2 = $AnimatedSprite2D2
@onready var ray_cast_2d = $RayCast2D

var is_moving = false


func _physics_process(delta):
	if is_moving == false:
		return
	
	if global_position == animated_sprite_2d_2.global_position:
		is_moving = false
		return
	
	animated_sprite_2d_2.global_position = animated_sprite_2d_2.global_position.move_toward(global_position, 1)


func _process(delta):
	if is_moving:
		return
		
	elif Input.is_action_pressed("move_up"):
		move(Vector2.UP)
	elif Input.is_action_pressed("move_left"):
		move(Vector2.LEFT)
	elif Input.is_action_pressed("move_down"):
		move(Vector2.DOWN)
	elif Input.is_action_pressed("move_right"):
		move(Vector2.RIGHT)
		
func move(direction: Vector2):
	
	# Get current tile Vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	
	# Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	#print(current_tile, target_tile)
	
	# Get custom data layer from target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		return
	
	ray_cast_2d.target_position = direction * 32
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding():
		return
	
	# Move player
	
	is_moving = true
	
	global_position = tile_map.map_to_local(target_tile)
	
	animated_sprite_2d_2.global_position = tile_map.map_to_local(current_tile)
