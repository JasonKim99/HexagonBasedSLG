extends TileMap

var directionToCube = {
	"东北": Vector3(1,0,-1),
	"东": Vector3(1,-1,0),
	"东南": Vector3(0,-1,1),
	"西北": Vector3(0,1,-1),
	"西": Vector3(-1,1,0),
	"西南": Vector3(-1,0,1)
}

var cubeToDirection = {
	Vector3(1,0,-1):"东北",
	Vector3(1,-1,0):"东",
	Vector3(0,-1,1):"东南",
	Vector3(0,1,-1):"西北",
	Vector3(-1,1,0):"西",
	Vector3(-1,0,1):"西南"
}

func oddrowToCube(tile: Vector2) -> Vector3:
	var col = tile.x as int
	var row = tile.y as int
	var x = col - (row - (row & 1)) / 2 as int
	var z = row
	var y = - x - z
	return Vector3(x,y,z)

func cubeToOddrow(cube: Vector3) -> Vector2:
	var x = cube.x as int
	var z = cube.z as int
	var col = x + ( z - (z & 1)) / 2 as int
	var row = z
	return Vector2(col,row)


func getAccurateTile(mousePos: Vector2):
	var tile = world_to_map(mousePos)
	var cube = oddrowToCube(tile)
	var selectedTile = tile
	#判断边界情况
	var tilePos = map_to_world(tile)
	var gapWidth = 13.5 / 25.5 * cell_size.x / 2
	var gapHeight = 13.5
	if mousePos.x < tilePos.x + gapWidth:
		if mousePos.y < tilePos.y + gapHeight:
			var pivotPos = tilePos + Vector2(gapWidth,0)
			var ang = rad2deg(mousePos.angle_to_point(pivotPos))
			if ang > 150:
				selectedTile = cubeToOddrow(cube + directionToCube["西北"])
		elif mousePos.y > tilePos.y + cell_size.y - gapHeight:
			var pivotPos = tilePos + Vector2(gapWidth,cell_size.y)
			var ang = rad2deg(mousePos.angle_to_point(pivotPos))
			if ang < -150:
				selectedTile = cubeToOddrow(cube + directionToCube["西南"])
	elif mousePos.x > tilePos.x + cell_size.x - gapWidth:
		if mousePos.y < tilePos.y + gapHeight:
			var pivotPos = tilePos + Vector2(cell_size.x - gapWidth , 0)
			var ang = rad2deg(mousePos.angle_to_point(pivotPos))
			if ang < 30:
				selectedTile = cubeToOddrow(cube + directionToCube["东北"])
		elif mousePos.y > tilePos.y + cell_size.y - gapHeight:
			var pivotPos = tilePos + Vector2(cell_size.x - gapWidth, cell_size.y)
			var ang = rad2deg(mousePos.angle_to_point(pivotPos))
			if ang > -30:
				selectedTile = cubeToOddrow(cube + directionToCube["东南"])
	return selectedTile



func _unhandled_input(event):
	if event.is_action_pressed("LeftClick"):
		print(getAccurateTile(get_global_mouse_position()))









