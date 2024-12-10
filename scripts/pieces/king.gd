extends ChessPiece
class_name King

func _init(_color) -> void:
    pieceName = "King"
    super(_color)

func checkMoves(position: Vector2i, board: Node2D) -> Array:
    var moveTargets = Array()
    var captureTargets = Array()

    var targetCoords
    var targetSquare
    for y in range(-1, 2):
        for x in range(-1, 2):
            if x == 0 && y == 0:
                continue
            targetCoords = position + Vector2i(x, y)
            if targetCoords.x >= 0 && targetCoords.x <= 7 && targetCoords.y >= 0 && targetCoords.y <= 7:
                targetSquare = board.getSquare(targetCoords)
                if targetSquare.getPiece() == null:
                    # Add logic to prevent moving into check
                    moveTargets.append(targetSquare)
                elif canCaptureTarget(targetSquare):
                    captureTargets.append(targetSquare)

    var output = Array()
    output.append(moveTargets)
    output.append(captureTargets)			
    return output