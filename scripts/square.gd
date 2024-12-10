extends Node

# Node references
@onready var _sprite: Sprite2D = $PieceSprite
@onready var _targetSprite: Sprite2D = $TargetSprite

# Piece in this square
var _currentPiece: ChessPiece = null

enum {MOVE, ATTACK}
# If this square is being targeted and whether that's for a capture
var target_state = -1

var board: Node2D
var coordinates: Vector2i

var WORLD_POS: Vector2
var target_pos: Vector2

var selected: bool = false
var isHovered: bool = false
var pieceTargets: Array

func _ready():
	SignalBus.connect("piece_selected", self._any_piece_selected)
	SignalBus.connect("clear_targets", self._clear_target)
	SignalBus.connect("move_here", self._move_piece)

func initialize(x: int, y: int, chessBoard: Node2D):
	coordinates = Vector2i(x, y)
	WORLD_POS = _sprite.position
	target_pos = _sprite.position
	board = chessBoard

func _process(delta) -> void:
	if target_pos != _sprite.position:
		_sprite.position = _sprite.position.lerp(target_pos, delta * 14)

	if _moving_squares:
		if target_pos.distance_to(_sprite.position) < .4:
			_move_finished()
			

func getPiece() -> ChessPiece:
	return _currentPiece

func setPiece(newPiece: ChessPiece) -> void:
	_currentPiece = newPiece
	setSprite(newPiece)

# Sprite Management

const PAWN_W = "res://assets/chess/white_pawn.png"
const PAWN_B = "res://assets/chess/black_pawn.png"
const BISHOP_W = "res://assets/chess/white_bishop.png"
const BISHOP_B = "res://assets/chess/black_bishop.png"
const KNIGHT_W = "res://assets/chess/white_knight.png"
const KNIGHT_B = "res://assets/chess/black_knight.png"
const ROOK_W = "res://assets/chess/white_rook.png"
const ROOK_B = "res://assets/chess/black_rook.png"
const QUEEN_W = "res://assets/chess/white_queen.png"
const QUEEN_B = "res://assets/chess/black_queen.png"
const KING_W = "res://assets/chess/white_king.png"
const KING_B = "res://assets/chess/black_king.png"

const MOVE_TARGET = "res://assets/chess/selection_dot.png"
const ATTACK_TARGET = "res://assets/chess/selection_target.png"

func setSprite(piece: ChessPiece) -> void:
	if piece == null:
		_sprite.texture = null
	elif piece.color == ChessPiece.WHITE:
		if piece.pieceName == "Pawn":
			_sprite.texture = preload(PAWN_W)
		if piece.pieceName == "Bishop":
			_sprite.texture = preload(BISHOP_W)
		if piece.pieceName == "Knight":
			_sprite.texture = preload(KNIGHT_W)
		if piece.pieceName == "Rook":
			_sprite.texture = preload(ROOK_W)
		if piece.pieceName == "Queen":
			_sprite.texture = preload(QUEEN_W)
		if piece.pieceName == "King":
			_sprite.texture = preload(KING_W)
	elif piece.color == ChessPiece.BLACK:
		if piece.pieceName == "Pawn":
			_sprite.texture = preload(PAWN_B)
		if piece.pieceName == "Bishop":
			_sprite.texture = preload(BISHOP_B)
		if piece.pieceName == "Knight":
			_sprite.texture = preload(KNIGHT_B)
		if piece.pieceName == "Rook":
			_sprite.texture = preload(ROOK_B)
		if piece.pieceName == "Queen":
			_sprite.texture = preload(QUEEN_B)
		if piece.pieceName == "King":
			_sprite.texture = preload(KING_B)


func _on_mouse_enter() -> void:
	if !selected && _currentPiece != null:
		if SignalBus.actionState == _currentPiece.color:
			target_pos = WORLD_POS + Vector2(0, -4)
	isHovered = true

func _on_mouse_exit() -> void:
	if !selected:
		_reset_world_pos()
	isHovered = false

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed && self.isHovered:
			if target_state == 0:
				SignalBus.emit_signal("move_here", self, false)
			elif target_state == 1:
				SignalBus.emit_signal("move_here", self, true)
			elif !selected && _currentPiece != null:
				# Enforce turn order and prevent simultaneous moves
				if SignalBus.actionState != _currentPiece.color:
					return

				SignalBus.emit_signal("clear_targets")
				SignalBus.emit_signal("piece_selected")
				select()
			else:
				selected = false
				SignalBus.emit_signal("clear_targets")
				_reset_world_pos()

func select():
	selected = true
	pieceTargets = _currentPiece.checkMoves(coordinates, board)
	target_pos = WORLD_POS + Vector2(0, -7)

	for t in pieceTargets[MOVE]:
		t.setTarget(MOVE)
	for t in pieceTargets[ATTACK]:
		t.setTarget(ATTACK)


func _reset_world_pos() -> void:
	target_pos = WORLD_POS

func _any_piece_selected() -> void:
	if !self.isHovered:
		selected = false
		_reset_world_pos()

func setTarget(type: int):
	target_state = type
	if type == MOVE:
		_targetSprite.texture = preload(MOVE_TARGET)
	elif type == ATTACK:
		_targetSprite.texture = preload(ATTACK_TARGET)

func _clear_target() -> void:
	_targetSprite.texture = null
	target_state = -1

var _moving_squares: bool = false
var destination: Node2D = null
func _move_piece(newSquare, isCapturing) -> void:
	if !selected:
		return

	destination = newSquare

	SignalBus.emit_signal("clear_targets")
	if isCapturing:
		newSquare.setPiece(null)
	
	_moving_squares = true
	var target_x = (newSquare.position.x - self.position.x)
	var target_y = (newSquare.position.y - self.position.y) 
	target_pos = Vector2(target_x, target_y)

func _move_finished():
	selected = false
	self._currentPiece.hasMoved = true
	_moving_squares = false
	destination.setPiece(self._currentPiece)
	destination = null
	self.setPiece(null)
	target_pos = WORLD_POS
	_sprite.position = WORLD_POS
	SignalBus.emit_signal("move_complete")