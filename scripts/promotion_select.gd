extends Node

@onready var QUEEN_SELECT = $Select/Queen/Area2D
@onready var KNIGHT_SELECT = $Select/Knight/Area2D
@onready var ROOK_SELECT = $Select/Rook/Area2D
@onready var BISHOP_SELECT = $Select/Bishop/Area2D

@onready var QUEEN_SPRITE: Sprite2D = $Select/Queen/Sprite
@onready var KNIGHT_SPRITE: Sprite2D = $Select/Knight/Sprite
@onready var ROOK_SPRITE: Sprite2D = $Select/Rook/Sprite
@onready var BISHOP_SPRITE: Sprite2D = $Select/Bishop/Sprite

signal color_set
signal piece_selected

var _color: int
var selectedPiece: ChessPiece = null

const BISHOP_W = "res://assets/chess/white_bishop.png"
const BISHOP_B = "res://assets/chess/black_bishop.png"
const KNIGHT_W = "res://assets/chess/white_knight.png"
const KNIGHT_B = "res://assets/chess/black_knight.png"
const ROOK_W = "res://assets/chess/white_rook.png"
const ROOK_B = "res://assets/chess/black_rook.png"
const QUEEN_W = "res://assets/chess/white_queen.png"
const QUEEN_B = "res://assets/chess/black_queen.png"

func _ready() -> void:
	QUEEN_SELECT.connect("input_event", _on_queen_input_event)
	KNIGHT_SELECT.connect("input_event", _on_knight_input_event)

	await color_set

	if _color == ChessPiece.WHITE:
		QUEEN_SPRITE.texture = preload(QUEEN_W)
		KNIGHT_SPRITE.texture = preload(KNIGHT_W)
		ROOK_SPRITE.texture = preload(ROOK_W)
		BISHOP_SPRITE.texture = preload(BISHOP_W)
	else:
		QUEEN_SPRITE.texture = preload(QUEEN_B)
		KNIGHT_SPRITE.texture = preload(KNIGHT_B)
		ROOK_SPRITE.texture = preload(ROOK_B)
		BISHOP_SPRITE.texture = preload(BISHOP_B)


func setColor(color: int):
	_color = color
	emit_signal("color_set")

func _on_queen_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
		selectedPiece = Queen.new(_color)
		emit_signal("piece_selected")

func _on_knight_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
		selectedPiece = Knight.new(_color)
		emit_signal("piece_selected")

func _on_rook_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
		selectedPiece = Rook.new(_color)
		emit_signal("piece_selected")

func _on_bishop_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
		selectedPiece = Bishop.new(_color)
		emit_signal("piece_selected")

func getSelectedPiece() -> ChessPiece:
	await piece_selected
	selectedPiece.hasMoved = true
	return selectedPiece
