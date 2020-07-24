extends Node2D

var distance = 14
var radius = 4

var time = 0
var noise: OpenSimplexNoise
var rows
var cols
var t = 0
var field = []

func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	rows = ceil(Game.w / distance) + 1
	cols = ceil(Game.h / distance) + 1
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 4
	noise.persistence = 0.1
	
	for i in rows:
		var row = []
		for j in cols:
			row.append(1)
		field.append(row)

	
func _draw():
	for i in rows - 1:
		for j in cols - 1:
			var el = field[i][j]
			
			var x = i * distance
			var y = j * distance
			
			var a = Vector2(x + distance * 0.5, y)
			var b = Vector2(x + distance, y + distance * 0.5)
			var c = Vector2(a.x, y + distance)
			var d = Vector2(x, b.y)
			var s = get_state(field, i, j)
#			print(s)
			var el_mod = (el + 1) / 2
			
			match s:
				1, 14:
					line(c, d, el_mod)
				2, 13:
					line(b, c, el_mod)
				3:
					line(b, d, el_mod)
				4, 11:
					line(a, b, el_mod)
				5:
					line(a, d, el_mod)
					line(b, c, el_mod)
				6, 9:
					line(a, c, el_mod)
				7, 8:
					line(a, d, el_mod)
				10:
					line(a, b, el_mod)
					line(c, d, el_mod)
				12:
					line(b, d, el_mod)
				_:
					pass
			
			var col = Color(0.2, el_mod, (1 - 0.5*el_mod), 1)
#			if el < 0:
#				col = col.linear_interpolate(Color(.1, .1, .1), el_mod)
#			else:
#				col = col.linear_interpolate(Color(.2, .2, .9), el_mod)
			draw_circle(Vector2(x, y), radius, col)

	
func line(p1, p2, alpha = .3):
	draw_line(p1, p2, Color(1, 1, 1, log(3.4*alpha)), 3)


func _process(delta):
	time += delta
	for i in rows:
		for j in cols:
			field[i][j] = noise.get_noise_3d(i, j, time)
	update()


func get_state(field, i, j) -> int:
	return int(
		8 * ceil(field[i][j]) +
		4 * ceil(field[i + 1][j]) +
		2 * ceil(field[i + 1][j + 1]) +
		1 * ceil(field[i][j + 1])
	)

