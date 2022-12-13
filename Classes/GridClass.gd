extends Node

class_name GridObject


#-------------------------------------------------------------------------------
# Private Variables
#-------------------------------------------------------------------------------

var UNIT = GlobalSettings.UNIT # dependency on another library, set to unit pixel size
var _ref_vector_array: Array


#-------------------------------------------------------------------------------
# Public Variables
#-------------------------------------------------------------------------------
signal GridGenerated

var is_grid_active: bool = false
var width: int = 4 : set = set_width
var height: int : set = set_height
var volume: int : set = set_volume
var spacing = 1 * UNIT : set = set_spacing
var rotation: float = 0 #: set = set_rotation
var center_position: Vector2 : set = set_center_position

var vector_array: Array

#-------------------------------------------------------------------------------
# SetGet
#-------------------------------------------------------------------------------
func set_width(new_width):
	var width_diff = new_width - width
	width = clamp(new_width, 1, volume)
	generate_box_grid()

func set_height(new_height):
	height = clamp(new_height, 1, volume)

func increment_width(width_increment):
	set_width(width + width_increment)


func set_volume(new_volume: int):
	volume = new_volume
	generate_box_grid()


func set_spacing(new_spacing):
	spacing = new_spacing #* UNIT

func set_rotation(new_rotation):
	rotation = new_rotation
	set_grid_rotation(vector_array, rotation)
	pass

func increment_rotation(rotation_increment):
	set_rotation(rotation + rotation_increment)


func set_center_position(new_center_position: Vector2):
	center_position = new_center_position
	set_grid_center_position(center_position)

#-------------------------------------------------------------------------------
# Grid Tools
#-------------------------------------------------------------------------------
func get_grid_center(new_grid: Array):
	var new_grid_center: Vector2 = Vector2.ZERO
	for index in new_grid:
		new_grid_center += index
	new_grid_center /= new_grid.size()
	return new_grid_center


func set_grid_spacing(new_grid, new_spacing):
#	new_spacing *= GlobalSettings.UNIT
	for index in new_grid.size():
		new_grid[index] *= new_spacing


func set_grid_center_position(new_center_position: Vector2 = center_position):
	var current_grid_center: Vector2 = get_grid_center(vector_array)
	var _offset: Vector2 = new_center_position - current_grid_center
	for index in vector_array.size():
		vector_array[index] += _offset


func set_grid_rotation(new_grid, new_rotation: float):
	for index in new_grid.size():
		var new_vector: Vector2 = _ref_vector_array[index].rotated(new_rotation)
		new_grid[index] = new_vector
	set_grid_center_position(center_position)


func increment_grid_rotation(new_grid, new_rotation: float):
	#uses reference vector array
	new_rotation = deg_to_rad(new_rotation)
	for index in new_grid.size():
		var new_vector: Vector2 = _ref_vector_array[index].rotated(new_rotation)
		new_grid[index] = new_vector


func generate_box_grid() -> Array:
	var grid: Array = []
	var temp: float = float(volume)/float(width)
	height = ceil(temp)
	if is_inf(height): print ("ERROR: Height is INF, WIDTH is ZERO") #throw error
	for y in height:
		for x in width:
			# add hollow grid
			var pos: Vector2
			if int(y) % 2 == 0:
				pos = Vector2(width - x -1, -y)
			else:
				pos = Vector2(x, -y)
			grid.append(pos)
	trim_grid_to_volume(grid, volume)
	set_grid_spacing(grid, spacing)
	_ref_vector_array = grid.duplicate() # create ref grid to use for absolute rotations
	set_grid_rotation(grid, rotation)
	vector_array = grid
	set_grid_center_position(center_position)
	GridGenerated.emit()
	return grid

func trim_grid_to_volume(new_grid, new_volume):
	var _offset = new_volume
	for index in (new_grid.size() - new_volume):
		new_grid.remove_at(_offset)
