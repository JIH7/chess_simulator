extends ChessPiece
class_name Queen

func _init(_color: int) -> void:
	pieceName = "Queen"
	pieceAbrev = "Q"
	super(_color)

func checkMoves(position: Vector2i, board: Node2D) -> Array:
	var moveTargets = Array()
	var captureTargets = Array()
	var targetSquare

	var pin = findPins(position, board)

	# Checks 8 vectors, skipping (0, 0)
	for y in range(-1, 2, 1):
		for x in range(-1, 2, 1):
			if x == 0 && y == 0:
				continue

			if pin != Vector2i(0, 0) && pin != Vector2i(x, y) && pin != Vector2i(-x, -y):
				continue
			
			var hasNext = true
			var checkCoords = position
			while hasNext:
				checkCoords += Vector2i(x, y)

				if (checkCoords.x >= 0 && checkCoords.x <= 7) && (checkCoords.y >= 0 && checkCoords.y <= 7):
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

	moveTargets = moveTargets.filter(func(t: Node): return validateTarget(t.coordinates))
	captureTargets = captureTargets.filter(func(t: Node): return validateTarget(t.coordinates))

	var output = Array()
	output.append(moveTargets)
	output.append(captureTargets)
	return output