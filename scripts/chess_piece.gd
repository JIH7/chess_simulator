class_name ChessPiece

var pieceName: String
enum {WHITE, BLACK}
var color: int
var hasMoved: bool = false

func _init(_color) -> void:
	color = _color

func getColor() -> String:
	if color == WHITE:
		return "White"
	else:
		return "Black"

func toString() -> String:
	return self.getColor() + " " + pieceName

func checkMoves(position: Vector2i, board: Node2D) -> Array:
	return Array()

func canCaptureTarget(square: Node2D) -> bool:
	var other = square.getPiece()
	if other != null:
		if other.color != color:
			return true
	return false
