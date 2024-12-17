extends Node2D

var grid: Array
var squareScene: PackedScene # Prefab for a square on the chessboard
var promotionSelectScene: PackedScene
var gameOverScene: PackedScene

var moveLedger: Array # Stores the game sequence in algebraic notation
var repeatTracker: Array # Stores the board state since the last pawn move or piece capture

func _ready() -> void:
	SignalBus.connect("check_game_over", _check_game_over)

	grid = Array()
	moveLedger = Array()
	squareScene = preload("res://prefabs/square.tscn")
	promotionSelectScene = preload("res://prefabs/promotion_select.tscn")
	gameOverScene = preload("res://prefabs/GameOverScreen.tscn")
	

	# Instantiate a grid of squares and move them to the proper coordinates
	for y: int in range(8):
		var row: Array = Array()
		for x: int in range(8):
			var newSquare: Node = squareScene.instantiate()
			newSquare.position = Vector2((x - 4) * 66 + 33, -((y - 4) * 66 + 33))
			add_child(newSquare)
			row.append(newSquare)
			newSquare.initialize(x, y, self)

			_populateSquare(newSquare)

		grid.append(row.duplicate())
	

# Initializes the board with a standard chess layout
func _populateSquare(square) -> void:
	if square.coordinates.y == 0:
		if square.coordinates.x == 0 || square.coordinates.x == 7:
			square.setPiece(Rook.new(ChessPiece.WHITE))
		elif square.coordinates.x == 1 || square.coordinates.x == 6:
			square.setPiece(Knight.new(ChessPiece.WHITE))
		elif square.coordinates.x == 2 || square.coordinates.x == 5:
			square.setPiece(Bishop.new(ChessPiece.WHITE))
		elif square.coordinates.x == 3:
			square.setPiece(Queen.new(ChessPiece.WHITE))
		elif square.coordinates.x == 4:
			square.setPiece(King.new(ChessPiece.WHITE))
			SignalBus.kings[ChessPiece.WHITE] = square
	elif square.coordinates.y == 1:
		square.setPiece(Pawn.new(ChessPiece.WHITE))
	elif square.coordinates.y == 7:
		if square.coordinates.x == 0 || square.coordinates.x == 7:
			square.setPiece(Rook.new(ChessPiece.BLACK))
		elif square.coordinates.x == 1 || square.coordinates.x == 6:
			square.setPiece(Knight.new(ChessPiece.BLACK))
		elif square.coordinates.x == 2 || square.coordinates.x == 5:
			square.setPiece(Bishop.new(ChessPiece.BLACK))
		elif square.coordinates.x == 3:
			square.setPiece(Queen.new(ChessPiece.BLACK))
		elif square.coordinates.x == 4:
			square.setPiece(King.new(ChessPiece.BLACK))
			SignalBus.kings[ChessPiece.BLACK] = square
	elif square.coordinates.y == 6:
		square.setPiece(Pawn.new(ChessPiece.BLACK))

# Returns the square at a given set of coordinates
func getSquare(coordinates: Vector2i) -> Node2D:
	return grid[coordinates.y][coordinates.x]

# Adds moves to a list. ToDO: Add rewind feature and PGN support
func addMove(move: String) -> void:
	moveLedger.append(move)
	print(move)

func openPromotionSelect(square):
	var promotionMenu = promotionSelectScene.instantiate()
	add_child(promotionMenu)
	promotionMenu.setColor(square.getPiece().color)
	return promotionMenu

func resetRepeatTracker():
	repeatTracker = Array()
	repeatTracker.append(_boardStateString())

func appendRepeatTracker():
	repeatTracker.append(_boardStateString())

func repeatDraw():
	var counts = {}
	for i in repeatTracker:
		if i in counts:
			counts[i] += 1
		else:
			counts[i] = 1
		if counts[i] == 3:
			return true
	return false

func _check_game_over():
	var pieces: Array = _get_flattened_grid()
	var legalMoveExists: bool = false
	pieces = pieces.filter(func(square) -> bool: return square.getPiece() != null).filter(func(square) -> bool: return square.getPiece().color == SignalBus.activePlayer)
	
	for square in pieces:
		var moveList = square.getPiece().checkMoves(square.coordinates, self)
		if !(moveList[0].size() == 0 && moveList[1].size() == 0):
			legalMoveExists = true

	if !legalMoveExists:
		if SignalBus.checks.size() != 0:
			# This function is called after the active player changes, so we check the opposite player
			_openGameOverScreen("Checkmate! " + ("White" if SignalBus.activePlayer == SignalBus.BLACK else "Black") + " wins!")
			return
		else:
			_openGameOverScreen("Stalemate. No legal moves.")
			return

	if repeatDraw():
		_openGameOverScreen("Stalemate. Repetition.")
		return

func _openGameOverScreen(result: String):
	SignalBus.lockGame()
	var endScreen = gameOverScene.instantiate()
	add_child(endScreen)
	endScreen.setText(result)
	print(result)

func _boardStateString():
	var flattenedBoard: Array
	var output: String = ""

	flattenedBoard = _get_flattened_grid()
	for i in flattenedBoard:
		var piece = i.getPiece()

		if piece == null:
			output += "-"
		elif piece.pieceName == "Pawn":
			output += "p"
		else:
			output += piece.pieceAbrev

	return output

func _get_flattened_grid() -> Array:
	var output = Array()
	for y in grid:
		for x in y:
			output.append(x)
	return output
