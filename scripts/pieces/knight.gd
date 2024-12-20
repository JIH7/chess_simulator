extends ChessPiece
class_name Knight

func _init(_color: int) -> void:
    pieceName = "Knight"
    pieceAbrev = "N"
    super(_color)

func checkMoves(position: Vector2i, board: Node2D) -> Array:
    var moveTargets = Array()
    var captureTargets = Array()

    if findPins(position, board) != Vector2i(0, 0):
        return [moveTargets, captureTargets] # Knights never have a legal move when pinned so we can return here

    for y in range(-1, 2, 2):
        for x in range(-1, 2, 2):
            var targetSquare
            var targetCoords = position + Vector2i(x * 2, y)
            if targetCoords.x >= 0 && targetCoords.x <= 7 && targetCoords.y >= 0 && targetCoords.y <= 7:
                targetSquare = board.getSquare(targetCoords)
                if targetSquare.getPiece() == null:
                    moveTargets.append(targetSquare)
                elif canCaptureTarget(targetSquare):
                    captureTargets.append(targetSquare)
            targetCoords = position + Vector2i(x, y * 2)
            if targetCoords.x >= 0 && targetCoords.x <= 7 && targetCoords.y >= 0 && targetCoords.y <= 7:
                targetSquare = board.getSquare(position + Vector2i(x, y * 2))
                if targetSquare.getPiece() == null:
                    moveTargets.append(targetSquare)
                elif canCaptureTarget(targetSquare):
                    captureTargets.append(targetSquare)

    moveTargets = moveTargets.filter(func(t: Node): return validateTarget(t.coordinates))
    captureTargets = captureTargets.filter(func(t: Node): return validateTarget(t.coordinates))

    var output = Array()
    output.append(moveTargets)
    output.append(captureTargets)			
    return output
