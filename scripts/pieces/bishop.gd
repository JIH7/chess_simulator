extends ChessPiece
class_name Bishop

func _init(_color: int) -> void:
	pieceName = "Bishop"
	pieceAbrev = "B"
	super(_color)

func checkMoves(position: Vector2i, board: Node2D) -> Array:
	var moveTargets = Array()
	var captureTargets = Array()

	# Innermost loop should be reached 4 total times to sweep each diagonal vector
	for y in range(-1, 2, 2):
		for x in range(-1, 2, 2):
			var hasNext = true
			var checkCoords = position
			while hasNext:
				checkCoords += Vector2i(x, y)

				if (checkCoords.x >= 0 && checkCoords.x <= 7) && (checkCoords.y >= 0 && checkCoords.y <= 7):
					var targetSquare = board.getSquare(checkCoords)
					if targetSquare.getPiece() == null:
						moveTargets.append(targetSquare)
					elif canCaptureTarget(targetSquare):
						captureTargets.append(targetSquare)
						hasNext = false
					else:
						hasNext = false
				else:
					hasNext = false

	var output = Array()
	output.append(moveTargets)
	output.append(captureTargets)
	return output
