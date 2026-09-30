// ----------------------------------------------------------------------------------------------------
// -- Code related to touch interactions (from Codea, not yet updated for Love2D)
// ----------------------------------------------------------------------------------------------------
// -- toggle booleans if clicked in areas where button / sliders are
import types.{Player, Game}
import ui.{drawUI}
import shoot.{playerPressedShootButton}

fn love_mousepressed(game: &mut Game, x: Float, y: Float, button: Int) {
    let love = getLove()
    
    // print(x)
    // print(y)

    // fun times
    // if shotInProgress == true {
    //     explode(x,y)
    // }

    // rectangle on bottom-right to detect pressing shoot button
    if game.shotInProgress == false && (x > (game.WIDTH - 100.0) && y > game.HEIGHT - 100.0) {
        playerPressedShootButton(game)
    }

    if game.shotInProgress == false {
        let clickNearShip = if game.turn == 1 {
            nearShip(x, y, &game.player1)
        } else {
            nearShip(x, y, &game.player2)
        }

        if clickNearShip == "force" {
            game.mouseXinitial = x
            game.draggingType = "force"
            game.dragging = true
            love.mouse.setCursor(game.dragCursor)
        } else if clickNearShip == "angle" {
            game.mouseXinitial = x
            game.draggingType = "angle"
            game.dragging = true
            love.mouse.setCursor(game.dragCursor)
        }
    }
}

// returns "force", "angle", 'no'
fn nearShip(x: Float, y: Float, playerN: &Player) -> String {
    let forceOffset = 100.0 * playerN.force / 5.0

    let distance = pow(pow((playerN.x - x), 2.0) + pow((playerN.y - y), 2.0), 0.5)

    if distance < clamp(forceOffset, 10.0, 90.0) {
        return "force"
    } else if distance < 100.0 {
        return "angle"
    } else {
        return "no"
    }
}


// short circuit the love.update fn with boolean
fn love_mousereleased(game: &mut Game, x: Float, y: Float, button: Int) {
    let love = getLove()
    game.dragging = false
    love.mouse.resetCursor()
}

// if the mouse is being dragged after clicking, update the values of force or angle
// uses distance from initial click for smoothly
fn love_update(game : &mut Game, dt : Float) {
    let love = getLove()

    if game.dragging {
        game.mouseXcurrent = love.mouse.getX()
        if game.mouseXinitial != game.mouseXcurrent {
            let diff = game.mouseXcurrent - game.mouseXinitial

            if game.draggingType == "angle" {
                if game.turn == 1 {
                    game.player1.angle = getAngle(&game.player1, diff)
                } else if game.turn == 2 {
                    game.player2.angle = getAngle(&game.player2, diff)
                }
            } else if game.draggingType == "force" {
                if game.turn == 1 {
                    game.player1.force = getForce(&game.player1, diff)
                } else if game.turn == 2 {
                    game.player2.force = getForce(&game.player2, diff)
                }
            }

            love.graphics.setCanvas(game.canvas)
            drawUI(game)
            love.graphics.resetCanvas()
        }
    }

    // -- if shotInProgress == false {
    // --     if keyUp {
    // --         game.player1.force = game.player1.force * 1.01
    // --     }
    // -- }
}

fn getForce(playerN : &Player, diff : Float) -> Float {
    clamp(playerN.force + clamp(pow(diff / 1000.0, 3.0), -0.02, 0.02), 0.0, 5.0)
}

fn getAngle(playerN : &Player, diff : Float) -> Float {
    mut angle = playerN.angle + clamp(pow(diff / 200.0, 3.0), -1.0, 1.0)
    if angle > 360.0 {
        angle = angle - 360.0
    } else if angle < 0.0 {
        angle = angle + 360.0
    }

    angle
}
