extends Node2D

var grid: Array
var squareScene: PackedScene

var moveLedger: Array

func _ready() -> void:
	grid = Array()
	moveLedger = Array()
	squareScene = preload("res://prefabs/square.tscn")

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
	elif square.coordinates.y == 6:
		square.setPiece(Pawn.new(ChessPiece.BLACK))

func getSquare(coordinates: Vector2i) -> Node2D:
	return grid[coordinates.y][coordinates.x]

func addMove(move: String) -> void:
	moveLedger.append(move)
	print(move)
