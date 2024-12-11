extends ChessPiece
class_name Knight

func _init(_color: int) -> void:
    pieceName = "Knight"
    pieceAbrev = "N"
    super(_color)

func checkMoves(position: Vector2i, board: Node2D) -> Array:
    var moveTargets = Array()
    var captureTargets = Array()

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

    var output = Array()
    output.append(moveTargets)
    output.append(captureTargets)			
    return output
