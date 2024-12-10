extends Node

enum {WHITE, BLACK, LOCKED}

var actionState: int = WHITE
var activePlayer: int = WHITE

signal piece_selected
signal clear_targets
signal move_here
signal move_complete

func _ready():
    connect("move_here", _lockOutPlayers)
    connect("move_complete", _changeTurns)

func _lockOutPlayers(_arg1, _arg2): # Function does not need argument, but the signal passes args for squares which need them
    actionState = LOCKED

func _changeTurns():
    if activePlayer == WHITE:
        actionState = BLACK
        activePlayer = BLACK
    else:
        actionState = WHITE
        activePlayer = WHITE