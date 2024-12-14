extends ChessPiece
class_name King

func _init(_color) -> void:
	pieceName = "King"
	pieceAbrev = "K"
	super(_color)

func checkMoves(position: Vector2i, board: Node2D) -> Array:
	var moveTargets = Array()
	var captureTargets = Array()

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
					# Add logic to prevent moving into check
					moveTargets.append(targetSquare)
				elif canCaptureTarget(targetSquare) && !squareIsAttacked:
					captureTargets.append(targetSquare)

	var output = Array()
	output.append(moveTargets)
	output.append(captureTargets)			
	return output

# Checks if an opponent's piece is attacking the square at position
func checkSquare(position, board) -> bool:
	for y in range(-1, 2):
		for x in range(-1, 2):
			if x == 0 && y == 0:
				continue

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

			var checkCoords: Vector2 = position

			while inBounds(checkCoords):
				checkCoords += Vector2(x, y)
				if !inBounds(checkCoords):
					break
				
				var otherPiece: ChessPiece = board.getSquare(checkCoords).getPiece()
				if otherPiece != null:
					if otherPiece.color == color:
						break
					else:
						if x == 0 || y == 0:
							if otherPiece.pieceAbrev == "Q" || otherPiece.pieceAbrev == "R":
								return true
							elif otherPiece.pieceAbrev == "K" && checkCoords.distance_squared_to(position) == 1:
								return true
							else:
								break
						else:
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
								break


	return false
