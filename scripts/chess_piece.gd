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

func hasMoves(position: Vector2i, board: Node2D) -> bool:
	var validMoves: Array = checkMoves(position, board)
	return (validMoves[0].size() > 0 || validMoves[1].size() > 0)

func controlSquare(position: Vector2i, board: Node2D) -> Array:
	return Array()

func findChecks(position: Vector2i, board: Node2D) -> Array:
	return Array()

# Returns the directional vector of a piece pinning this piece to the king
func findPins(position: Vector2i, board: Node2D) -> Vector2i:
	for y in range(-1, 2):
		for x in range(-1, 2):
			if x == 0 && y == 0:
				continue # No need for the piece to check it's own square

			# checkcoords is used to check a line in each direction for a king, then reused to check a line in the opposite vector if it's found
			var checkCoords: Vector2i = position
			var hasTarget: bool = true

			while hasTarget:
				checkCoords += Vector2i(x, y) # Increment to the next square in the current direction
				if inBounds(checkCoords):
					var targetPiece: ChessPiece = board.getSquare(checkCoords).getPiece()
					if targetPiece != null:
						hasTarget = false # Piece can only be pinned from one direction

						if targetPiece.pieceAbrev == "K" && targetPiece.color == self.color:
							checkCoords = position # Reset checkcoords to sweep the opposite direction of found king

							while inBounds(checkCoords):
								checkCoords -= Vector2i(x, y) # Increment next square away from king
								if !inBounds(checkCoords): # Break loop if edge of the board is reached
									break

								targetPiece = board.getSquare(checkCoords).getPiece()
								if targetPiece == null: # Advance if a piece has not been reached
									continue
								elif targetPiece.color == color:
									return Vector2i(0, 0)
								
								if x == 0 || y == 0: # Check orthogonally for Rooks and Queens
									if (targetPiece.pieceAbrev == "R" || targetPiece.pieceAbrev == "Q") && targetPiece.color != self.color:
										return Vector2i(-x, -y)
								else: # Check diagonally for Bishops and Queens
									if (targetPiece.pieceAbrev == "B" || targetPiece.pieceAbrev == "Q") && targetPiece.color != self.color:
										return Vector2i(-x, -y)
										
				else: # Exit loop at edge of board
					hasTarget = false
	
	return Vector2i(0,0)

# Checks if a piece exists and can be captured
func canCaptureTarget(square: Node2D) -> bool:
	var other = square.getPiece()
	if other != null:
		if other.color != color:
			return true
	return false

func inBounds(coords: Vector2i) -> bool:
	return (coords.x >= 0 && coords.x <= 7 && coords.y >= 0 && coords.y <=7)
