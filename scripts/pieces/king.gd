extends ChessPiece
class_name King

var _targetRooks: Array

func _init(_color) -> void:
	pieceName = "King"
	pieceAbrev = "K"
	super(_color)

func checkMoves(position: Vector2i, board: Node2D) -> Array:
	var moveTargets = Array()
	var captureTargets = Array()

	_targetRooks = Array()
	var targetCoords
	var targetSquare
	for y in range(-1, 2):
		for x in range(-1, 2):
			if x == 0 && y == 0:
				continue
			targetCoords = position + Vector2i(x, y)
			if targetCoords.x >= 0 && targetCoords.x <= 7 && targetCoords.y >= 0 && targetCoords.y <= 7:
				targetSquare = board.getSquare(targetCoords)
				var squareIsAttacked: bool = checkSquare(targetCoords, board)
				if targetSquare.getPiece() == null && !squareIsAttacked:
					moveTargets.append(targetSquare)
				elif canCaptureTarget(targetSquare) && !squareIsAttacked:
					captureTargets.append(targetSquare)

	# Check for castle moves
	if !hasMoved:
		for x in range(-1, 2, 2):
			targetCoords = position + Vector2i(x, 0)
			while inBounds(targetCoords):
				if abs(targetCoords.x - position.x) <= 2:
					if checkSquare(targetCoords, board):
						break
				
				targetSquare = board.getSquare(targetCoords)
				if targetSquare.getPiece() != null:
					if targetSquare.getPiece().pieceAbrev == "R" && !targetSquare.getPiece().hasMoved:
						moveTargets.append(board.getSquare(position + Vector2i(x * 2, 0)))
						_targetRooks.append(targetSquare)
						break
					else:
						break

				targetCoords += Vector2i(x, 0)

	var output = Array()
	output.append(moveTargets)
	output.append(captureTargets)			
	return output

"""Checks if an opponent's piece threatens a square. Position is the square we are checking. Returns true
if the square is under attack, returns false otherwise."""
func checkSquare(position, board) -> bool:
	for y in range(-1, 2): # Loop over each direction
		for x in range(-1, 2):
			if x == 0 && y == 0:
				continue

			if !(x == 0 || y == 0): # Check for knights when working with the four diagonals.
				if inBounds(position + Vector2i(x * 2, y)):
					var knightCheck: ChessPiece = board.getSquare(position + Vector2i(x * 2, y)).getPiece()
					if knightCheck != null:
						if knightCheck.pieceAbrev == "N" && knightCheck.color != color:
							return true
				if inBounds(position + Vector2i(x, y * 2)):
					var knightCheck = board.getSquare(position + Vector2i(x, y * 2)).getPiece()
					if knightCheck != null:
						if knightCheck.pieceAbrev == "N" && knightCheck.color != color:
							return true

			var checkCoords: Vector2 = position # Holder variable used when sweeping a direction

			while inBounds(checkCoords): # ToDo: See if there's a cleaner way to handle this loop
				checkCoords += Vector2(x, y)
				if !inBounds(checkCoords):
					break
				# Check if a piece exists at the current coordinates and handle accordingly
				var otherPiece: ChessPiece = board.getSquare(checkCoords).getPiece()
				if otherPiece != null:
					if otherPiece.color == color:
						if otherPiece.pieceAbrev == "K":
							continue # Treat self as an empty square so that bishops/rooks/queens can "laser" through the king
						else:
							break
					else:
						if x == 0 || y == 0: # Orthogonal directions
							if otherPiece.pieceAbrev == "Q" || otherPiece.pieceAbrev == "R":
								return true
							elif otherPiece.pieceAbrev == "K" && checkCoords.distance_squared_to(position) == 1:
								return true
							else: # If we encounter a piece that cannot attack orthogonally, this direction is safe
								break
						else: # Diagonal directions
							if otherPiece.pieceAbrev == "Q" || otherPiece.pieceAbrev == "B":
								return true
							elif checkCoords.distance_squared_to(position) == 2:
								if otherPiece.pieceAbrev == "K":
									return true
								elif otherPiece.pieceName == "Pawn" && ((color == WHITE && y == 1) || (color == BLACK && y == -1)):
									return true
								else:
									break 
							else:
								break # If we encounter a piece that cannot attack diagonally, this direction is safe
	return false

func castle(dirSign: int, targetSquare: Node, board: Node):
	for r in _targetRooks:
		if r.coordinates.x == 0 && dirSign == -1:
			r.rook_castle_move(board.getSquare(targetSquare.coordinates - Vector2i(dirSign * 2, 0)))
		if r.coordinates.x == 7 && dirSign == 1:
			r.rook_castle_move(board.getSquare(targetSquare.coordinates - Vector2i(dirSign * 2, 0)))