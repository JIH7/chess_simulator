extends Node

"""This is a singleton used to manage global signals. I have also used it as
a sort of game manager singleton for certain things such as turn management and
tracking check. If this aspect continues to grow I may need to create a dedicated
 game manager."""

enum {WHITE, BLACK, LOCKED}

var actionState: int = WHITE
var activePlayer: int = WHITE
var legalMoveExists: bool

var checks: Array
var kings: Array

signal piece_selected
signal clear_targets
signal move_here
signal move_complete
signal check_game_over

func _ready():
	checks = Array()
	kings = [null, null]
	connect("move_here", _lockOutPlayers)
	connect("move_complete", _changeTurns)

func _lockOutPlayers(_arg1, _arg2): # Function does not need argument, but the signal passes args for squares which need them
	actionState = LOCKED

func _changeTurns(): # Removes actionstate locks and advance turns
	if activePlayer == WHITE:
		actionState = BLACK
		activePlayer = BLACK
	else:
		actionState = WHITE
		activePlayer = WHITE

	emit_signal("clear_targets")
	emit_signal("check_game_over")

func addCheck(check: Node2D):
	checks.append(check)
	if check.getPiece().color == ChessPiece.WHITE:
		kings[1].setTarget(Square.CHECK)
	else:
		kings[0].setTarget(Square.CHECK)

func clearChecks():
	checks = Array()

func hasCheck() -> bool:
	return checks.size() > 0

func getKing(color: int) -> Node2D:
	return kings[color]

func setKing(color: int, square: Node2D):
	kings[color] = square

func getDirection(pos1: Vector2, pos2: Vector2) -> Vector2:
	var dir = Vector2(pos1.x, pos1.y).direction_to(Vector2(pos2.x, pos2.y))
	
	if abs(dir.x) == abs(dir.y):
		dir.x = dir.x / abs(dir.x)
		dir.y = dir.y / abs(dir.y)

	if dir.x == round(dir.x) && dir.y == round(dir.y):
		return dir
	else:
		return Vector2(0, 0)

	