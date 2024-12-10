class_name ChessPiece

var pieceName: String
enum {WHITE, BLACK}
var color: int

func _init(_color) -> void:
	color = _color

func getColor() -> String:
	if color == WHITE:
		return "White"
	else:
		return "Black"

func toString() -> String:
	return self.getColor() + " " + pieceName