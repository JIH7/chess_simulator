class_name ChessPiece

var pieceName: String
var pieceAbrev: String = ""
enum {WHITE, BLACK}
var color: int
var hasMoved: bool = false
var controlledSquares: Array

func _init(_color: int) -> void:
	color = _color
	controlledSquares = Array()

# Access color as string
func getColor() -> String:
	if color == WHITE:
		return "White"
	else:
		return "Black"

func toString() -> String:
	return self.getColor() + " " + pieceName

func checkMoves(position: Vector2i, board: Node2D) -> Array:
	return Array()

func controlSquare(position: Vector2i, board: Node2D) -> Array:
	return Array()

func findChecks(position: Vector2i, board: Node2D) -> Array:
	return Array()

# Checks if a piece exists and can be captured
func canCaptureTarget(square: Node2D) -> bool:
	var other = square.getPiece()
	if other != null:
		if other.color != color:
			return true
	return false
