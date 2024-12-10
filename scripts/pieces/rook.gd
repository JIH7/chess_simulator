extends ChessPiece
class_name Rook

func _init(_color: int) -> void:
    pieceName = "Rook"
    super(_color)

func checkMoves(position: Vector2i, board: Node2D) -> Array:
    var moveTargets = Array()
    var captureTargets = Array()

    var targetSquare
    for y in range(-1, 2, 2):
        var hasNext = true
        var checkCoords = position

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