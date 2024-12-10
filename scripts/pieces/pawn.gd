extends ChessPiece
class_name Pawn

func _init(_color: int) -> void:
	pieceName = "Pawn"
	super(_color)

func checkMoves(position: Vector2i, board: Node2D) -> Array:
	var moveTargets = Array()
	var captureTargets = Array()

	var x = position.x
	var y = position.y

	# Pawns need to check moves based on color since they only move forwards
	if color == WHITE:
		var targetSquare = board.getSquare(Vector2i(x, y + 1))
		# Check one square ahead
		if targetSquare.getPiece() == null:
			moveTargets.append(targetSquare)
			# Check for a valid double step move
			if !hasMoved:
				targetSquare = board.getSquare(Vector2i(x, y + 2))
				if targetSquare.getPiece() == null:
					moveTargets.append(targetSquare)
		# Check to the left, avoiding index out of bounds
		if x > 0:
			targetSquare = board.getSquare(Vector2i(x - 1, y + 1))
			if canCaptureTarget(targetSquare):
				captureTargets.append(targetSquare)
		# Check to the right
		if x < 7:
			targetSquare = board.getSquare(Vector2i(x + 1, y + 1))
			if canCaptureTarget(targetSquare):
				captureTargets.append(targetSquare)
	if color == BLACK:
		var targetSquare = board.getSquare(Vector2i(x, y - 1))
		# Check one square ahead
		if targetSquare.getPiece() == null:
			moveTargets.append(targetSquare)
			# Check for valid double step move
			if !hasMoved:
				targetSquare = board.getSquare(Vector2i(x, y - 2))
				if targetSquare.getPiece() == null:
					moveTargets.append(targetSquare)
		# Check to the left, avoiding index out of bounds
		if x > 0:
			targetSquare = board.getSquare(Vector2i(x - 1, y - 1))
			if canCaptureTarget(targetSquare):
				captureTargets.append(targetSquare)
		# Check to the right
		if x < 7:
			targetSquare = board.getSquare(Vector2i(x + 1, y - 1))
			if canCaptureTarget(targetSquare):
				captureTargets.append(targetSquare)
	var output = Array()
	output.append(moveTargets)
	output.append(captureTargets)			
	return output

