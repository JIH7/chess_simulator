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
	var pin: Vector2i = findPins(position, board);

	var moveDir: int
	if color == WHITE:
		moveDir = 1
	else:
		moveDir = -1

	# Pawns need to check moves based on color since they only move forwards
	var targetSquare = board.getSquare(Vector2i(x, y + moveDir))
	# Check one square ahead
	if targetSquare.getPiece() == null && pin.x == 0: # Check square ahead is open and not horizontally/diagonally pinned
		moveTargets.append(targetSquare)
		# Check for a valid double step move
		if !hasMoved:
			targetSquare = board.getSquare(Vector2i(x, y + (2 * moveDir)))
			if targetSquare.getPiece() == null:
				moveTargets.append(targetSquare)
	# Check to the left, avoiding index out of bounds
	if x > 0:
		targetSquare = board.getSquare(Vector2i(x - 1, y + moveDir))
		if (canCaptureTarget(targetSquare) || targetSquare.getCanEP()) && (pin == Vector2i(0, 0) || pin == Vector2i(-1, moveDir)):
			captureTargets.append(targetSquare)
	# Check to the right
	if x < 7:
		targetSquare = board.getSquare(Vector2i(x + 1, y + moveDir))
		if (canCaptureTarget(targetSquare) || targetSquare.getCanEP()) && (pin == Vector2i(0, 0) || pin == Vector2i(1, moveDir)):
			captureTargets.append(targetSquare)
	var output = Array()
	
	moveTargets = moveTargets.filter(func(t: Node): return validateTarget(t.coordinates))
	captureTargets = captureTargets.filter(func(t: Node): return validateTarget(t.coordinates))

	output.append(moveTargets)
	output.append(captureTargets)
	return output

func findChecks(position: Vector2i, board: Node2D) -> Array:
	var checkTargets: Array = Array()

	var x: int = position.x
	var y: int = position.y
	var targetSquare: Node
	if color == WHITE:
		if x > 0:
			targetSquare = board.getSquare(Vector2i(x - 1, y + 1))
			if canCaptureTarget(targetSquare):
				checkTargets.append(targetSquare)
		# Check to the right
		if x < 7:
			targetSquare = board.getSquare(Vector2i(x + 1, y + 1))
			if canCaptureTarget(targetSquare):
				checkTargets.append(targetSquare)

	return Array()