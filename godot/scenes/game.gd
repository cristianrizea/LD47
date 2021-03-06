extends Node2D

signal game_over

var _player
var _add_tile = false
var _game_over = false
var _score = 0

func _ready():
	$player.configure($map)
	$player.set_map_position(Consts.START_SQUARE_ROW, Consts.START_SQUARE_COLUMN + 1)
	var _dummy = $player.connect("player_moved", self, "_on_player_moved")
	_dummy = $player.connect("player_died", self, "_on_player_died")
	_dummy = $map.connect("segment_deleted", self, "_on_segment_deleted")
	$score.set_label("SCORE: " + str(_score))

func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
#		player.advance()
		if not _game_over:
			Input.action_release("ui_select")
			_add_tile = true
			$player.advance()


func _on_player_moved(old_row, old_column, _row, _column):
#	print("player moved ", [old_row, old_column, row, column])
	if _add_tile:
		# print("adding tile")
		_add_tile = false
		$advance_timer.wait_time = 1
		$advance_timer.start()
		$map.add_tile(old_row, old_column, $next_items.get_next_tile_number())
		$next_items.advance()


func _on_player_died():
	_game_over = true
	emit_signal("game_over")


func _on_segment_deleted(size, tile_number):
	_score += size * size
	$score.set_label("SCORE: " + str(_score))


func _on_advance_timer_timeout():
	if not _game_over:
		$player.advance()
	$advance_timer.wait_time -= Consts.PLAYER_ADVANCE_INTERVAL_CHANGE
	if $advance_timer.wait_time < Consts.MIN_PLAYER_ADVANCE_INTERVAL:
		$advance_timer.wait_time = Consts.MIN_PLAYER_ADVANCE_INTERVAL


# just for testing menus
func _on_game_over_timer_timeout():
#	_game_over = true
#	emit_signal("game_over")
	pass
