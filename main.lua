// ----------------------------------------------------------------------------------------------------
// -- Code for imports, the initial load, and the `draw` loop
// ----------------------------------------------------------------------------------------------------
import types.{Player, Color, Game}
import globals.{loadExternalAssets, setVariables}
import ui.{drawShips, drawUI, drawForceAndAngle}
import shoot.{playerPressedShootButton}
import logic.{newGame, collisonCheck, drawShot}
import touch
import keyboard

// Use this function to perform your initial setup
fn love_load() -> Game {
    let love = getLove()

    // Real assets, loaded once up front: `Image`/`Font`/`Cursor`/`Canvas` are
    // opaque host handles, so the `Game` literal below needs working ones,
    // not placeholders. `loadExternalAssets`/`setVariables` (globals.air)
    // still do the "real" load right after; love-air caches by path, so
    // that second load is free.
    let dragCursor = love.mouse.getSystemCursor("sizewe")
    let canvas = love.graphics.newCanvas(1000, 800)
    let canvas2 = love.graphics.newCanvas(1000, 800)

    mut game = Game { x: 0.0,
        allPlanets: [],
        allBullets: [],
        turn: 1,
        shotInProgress: false,
        dragging: false,
        draggingType: "",
        mouseXinitial: 0.0,
        mouseYinitial: 0.0,
        mouseXcurrent: 0.0,
        mouseYcurrent: 0.0,
        benign: 0,
        bulletsInFlight: false,
        endOfRound: false,
        colorMode: 0,
        bulType: 1,
        keyRight: false,
        keyLeft: false,
        keyUp: false,
        keyDown: false,
        rainbow: Color { r: 0.0, g: 0.0, b: 0.0, a: 1.0 },
        assets: loadExternalAssets(),
        dragCursor,
        canvas,
        canvas2,
        numOfBullets: 0,
        numOfPlanets: 0,
        WIDTH: 1000.0,
        HEIGHT: 800.0,
        player1: Player { x: 100.0, y: 100.0, angle: 0.0, force: 1.5, lives: 3, health: 100, lastAngle: 0.0, lastForce: 0.0 },
        player2: Player { x: 500.0, y: 500.0, angle: 180.0, force: 1.5, lives: 3, health: 100, lastAngle: 0.0, lastForce: 0.0 },
        shipX: 0.0,
        shipY: 0.0,
    }

    setVariables(&mut game) //-- globals.lua

    love.window.setMode(int(game.WIDTH), int(game.HEIGHT))

    newGame(&mut game)

    // playerPressedShootButton(&mut game) // disable this to let the player take the first shot

    game
}

// This function gets called once every frame
fn love_draw(game: &mut Game) {
    let love = getLove()
    // love.graphics.setBackgroundColor(0,0,50/255)

    if game.endOfRound == true && game.shotInProgress == false {
        game.endOfRound = false
        newGame(game)
    }

    if game.colorMode == 1 {
        // this has potential to run over (how many minutes till it crashes?)
        // might want it to reset to 0 sometimes
        game.rainbow.r = game.rainbow.r + 1.0
        game.rainbow.g = game.rainbow.g + 2.0
        game.rainbow.b = game.rainbow.b + 3.0

        // this code oscilates the color all the time (mathematically heavy)
        love.graphics.setColor(floor(200.0 * abs(sin(game.rainbow.r * 0.005)) + 54.0) / 255.0,
                               floor(200.0 * abs(sin(game.rainbow.g * 0.004)) + 54.0) / 255.0,
                               floor(200.0 * abs(sin(game.rainbow.b * 0.003)) + 54.0) / 255.0, 1.0)
    } else if game.colorMode == 2 {
        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    }

    // only draw things if shot is in progress
    if game.shotInProgress == true {
        for i in 0..game.numOfBullets { drawShot(game, i) }

        for i in 0..game.numOfBullets { collisonCheck(game, i) }

        game.benign = game.benign + 1 // benign makes your own bullet not kill you for the first few moments when you shoot

        game.bulletsInFlight = false // TODO: fix this hacky thing: if the x location of each shot == 0 then end the turn
        for bullet in &game.allBullets {
            if bullet.x != 0.0 && bullet.y != 0.0 {
                game.bulletsInFlight = true // HACK -- assumes position of disabled bullet is = (0, 0)
            }
        }

        if game.bulletsInFlight == false {
            print("all shots have finished")

            game.shotInProgress = false

            if game.turn == 1 {
                game.turn = 2
            } else if game.turn == 2 {
                game.turn = 1
            }

            love.graphics.setCanvas(game.canvas)
            drawUI(game)
            love.graphics.resetCanvas()
        }

    }

    // this code here WILL dim the trails continuously when explosion occurs
    // works too fast so I can slow it down by dimming every 5th frame (temp int)
    // if benign < 0 then dimTrails() end

    // drawUI() -- maybe do not draw continuously ?

    // starts dimming the playing field more aggressively
    if game.endOfRound == true {
        // dimTrails()
        // love.graphics.setColor(0,0,0,1)
        // love.graphics.rectangle('fill',-1,-1,WIDTH+5,HEIGHT+5)
    }

    // RENDER THE CANVAS NOW
    love.graphics.drawCanvas(game.canvas, 0.0, 0.0, 1.0, 1.0)

    if game.shotInProgress == false {

        love.graphics.setCanvas(game.canvas2)
        love.graphics.clear(0.0, 0.0, 0.0, 0.0)

        if game.turn == 1 {
            drawPlayerAngleAndForce(&game.player1)
            if game.player1.lastAngle != 0.0 {
                drawAngleDiff(game, 1, 0)
            }
            drawForceAndAngle(game, 1, 1)
        } else {
            drawPlayerAngleAndForce(&game.player2)
            if game.player2.lastAngle != 0.0 {
                drawAngleDiff(game, 2, 1)
            }
            drawForceAndAngle(game, 2, 2)
        }

        love.graphics.resetCanvas()
        love.graphics.drawCanvas(game.canvas2, 0.0, 0.0, 1.0, 1.0)

    }

    drawShips(game)

    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
}


fn drawPlayerAngleAndForce(playerN : &Player) {
    let love = getLove()

    // large black circle
    love.graphics.setColor(0.0, 0.0, 0.0, 0.6)
    love.graphics.ellipse("fill", playerN.x, playerN.y, 100.0, 100.0)

    // red arc showing force
    love.graphics.setColor(1.0, 0.0, 0.0, 1.0)
    love.graphics.arc("fill", "pie", playerN.x, playerN.y, playerN.force * 20.0, 0.0174533 * playerN.angle - 0.1, 0.0174533 * playerN.angle + 0.1)

    // smaller red circle showing force
    love.graphics.setColor(1.0, 0.0, 0.0, 0.4)
    love.graphics.ellipse("line", playerN.x, playerN.y, playerN.force * 20.0, playerN.force * 20.0)

    // love.graphics.setColor(1, 0, 0, 1)
    // love.graphics.line(playerN.x, playerN.y,
    //                     playerN.x + math.cos(0.0174533 * playerN.angle) * 100 * playerN.force / 5,
    //                     playerN.y + math.sin(0.0174533 * playerN.angle) * 100 * playerN.force / 5)

    // large white circle showing maximum
    love.graphics.setColor(1.0, 1.0, 1.0, 0.6)
    love.graphics.ellipse("line", playerN.x, playerN.y, 100.0, 100.0)

    // long line showing angle
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.ellipse("line", playerN.x, playerN.y, 10.0, 10.0)
    love.graphics.line(playerN.x, playerN.y,
                        playerN.x + cos(0.0174533 * playerN.angle) * 100.0,
                        playerN.y + sin(0.0174533 * playerN.angle) * 100.0)
}

fn drawAngleDiff(game : &Game, which : Int, playerOffsetHack : Int) {
    let love = getLove()

    let lastAngle = if which == 1 { game.player1.lastAngle } else { game.player2.lastAngle }
    let angle = if which == 1 { game.player1.angle } else { game.player2.angle }
    let force = if which == 1 { game.player1.force } else { game.player2.force }
    let lastForce = if which == 1 { game.player1.lastForce } else { game.player2.lastForce }
    let px = if which == 1 { game.player1.x } else { game.player2.x }
    let py = if which == 1 { game.player1.y } else { game.player2.y }

    mut angleDiff = lastAngle - angle

    let forceDiff = force - lastForce

    if angleDiff > 180.0 {
        angleDiff = angleDiff - 360.0
    }

    if angleDiff < -180.0 {
        angleDiff = angleDiff + 360.0
    }

    if angleDiff < 10.0 && angleDiff > -10.0 {

        let xOffset = px - 76.0 + float(playerOffsetHack) * 90.0

        let fontOpacity = pow(abs(10.0 - abs(angleDiff)) / 10.0, 0.5)
        love.graphics.setFont(game.assets.pixelFont)

        if angleDiff != 0.0 {
            // rectangle
            love.graphics.setColor(0.0, 0.0, 0.0, 0.5)
            love.graphics.rectangle("fill", xOffset + 5.0, py - 6.0, 56.0, 12.0)
            // text
            love.graphics.setColor(1.0, 1.0, 1.0, fontOpacity)
            love.graphics.draw_text_aligned("{fmt_float(angleDiff, 5)}", xOffset, py - 7.0, 60.0, "right")
        }

        love.graphics.setColor(1.0, 0.0, 0.0, fontOpacity)

        if forceDiff != 0.0 {
            // rectangle
            love.graphics.setColor(0.0, 0.0, 0.0, 0.5)
            love.graphics.rectangle("fill", xOffset + 5.0, py + 6.0, 56.0, 12.0)
            // text
            love.graphics.setColor(1.0, 0.0, 0.0, fontOpacity)
            love.graphics.draw_text_aligned("{fmt_float(forceDiff, 5)}", xOffset, py + 5.0, 60.0, "right")
        }

        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    }
}

fn love_mousepressed(game: &mut Game, x: Float, y: Float, button: Int) {
    touch.love_mousepressed(game, x, y, button)
}

fn love_update(game: &mut Game, dt: Float) {
    touch.love_update(game, dt)
}

fn love_mousereleased(game: &mut Game, x: Float, y: Float, button: Int) {
    touch.love_mousereleased(game, x, y, button)
}

fn love_keypressed(game: &mut Game, key: String) {
   keyboard.love_keypressed(game, key)
}

fn love_keyreleased(game: &mut Game, key: String) {
   keyboard.love_keyreleased(game, key)
}