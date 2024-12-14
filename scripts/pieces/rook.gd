extends ChessPiece
class_name Rook

func _init(_color: int) -> void:
	pieceName = "Rook"
	pieceAbrev = "R"
	super(_color)

func checkMoves(position: Vector2i, board: Node2D) -> Array:
	var moveTargets = Array()
	var captureTargets = Array()

	var pin = findPins(position, board)

	var targetSquare
	for y in range(-1, 2, 2):
		var hasNext = true
		var checkCoords = position

		if pin.x != 0:
			break

		while hasNext:
			checkCoords += Vector2i(0, y)
			if checkCoords.y >= 0 && checkCoords.y <= 7:
				targetSquare = board.getSquare(checkCoords)
				if targetSquare.getPiece() == null:
					moveTargets.append(targetSquare)
				elif canCaptureTarget(targetSquare):
					captureTargets.append(targetSquare)
					hasNext = false
				else:
					hasNext = false
			else:
				hasNext = false

	for x in range(-1, 2, 2):
		var hasNext = true
		var checkCoords = position

		if pin.y != 0:
			break

		while hasNext:
			checkCoords += Vector2i(x, 0)
			if checkCoords.x >= 0 && checkCoords.x <= 7:
				targetSquare = board.getSquare(checkCoords)
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
