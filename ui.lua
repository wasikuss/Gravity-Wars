// ----------------------------------------------------------------------------------------------------
// -- Code related to drawing the UI (user interface)
// ----------------------------------------------------------------------------------------------------
import types.{Player, Game}

fn drawUI(game : &Game) {
    let love = getLove()

    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)

    // rectangle for health bars and around play area
    love.graphics.rectangle("line", 2.0, 2.0, game.WIDTH - 4.0, 30.0)
    love.graphics.rectangle("line", 2.0, 32.0, game.WIDTH - 4.0, game.HEIGHT - 34.0)

    drawShootButton(game)

    drawLives(game)

    drawHealthBars(game)

    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
}

// shoot BUTTON rectangle -- change states while shot in progress
fn drawShootButton(game : &Game) {
    let love = getLove()

    if game.shotInProgress == true {
        love.graphics.setColor(0.5, 0.0, 0.0, 1.0)
    } else {
        love.graphics.setColor(16.0 / 255.0, 178.0 / 255.0, 197.0 / 255.0, 1.0)
    }
    love.graphics.ellipse("fill", game.WIDTH - 50.0, game.HEIGHT - 50.0, 30.0, 30.0)
}

// draw how many lives each has
fn drawLives(game : &Game) {
    let love = getLove()

    love.graphics.setColor(1.0, 1.0, 0.0, 1.0)
    for i in 0..game.player1.lives {
        love.graphics
            .ellipse("fill", game.WIDTH / 2.0 + 35.0 + 20.0 * float(i), 16.0, 8.0, 8.0)
    }

    for i in 0..game.player2.lives {
        love.graphics
            .ellipse("fill", game.WIDTH / 2.0 - 35.0 - 20.0 * float(i), 16.0, 8.0, 8.0)
    }
}

// draw health bars - responsive depending on WIDTH
fn drawHealthBars(game : &Game) {
    let love = getLove()

    let topOffset = 10.0

    let barWidth = game.WIDTH / 2.0 - 200.0

    let health1 = float(game.player1.health)
    let health2 = float(game.player2.health)

    // right health bar
    love.graphics.setColor((255.0 - health1 * 2.55) / 255.0, 1.0, 0.0, 1.0)
    love.graphics.rectangle("fill", game.WIDTH / 2.0 + 150.0, topOffset, barWidth, 10.0)

    if game.player1.health < 100 {
        love.graphics.setColor(223.0 / 255.0, (45.0 + health1) / 255.0,
                               (45.0 + health1) / 255.0, 1.0)
        love.graphics.rectangle("fill", (game.WIDTH / 2.0 + 150.0) + barWidth - barWidth *
                                    ((100.0 - health1) / 100.0), topOffset,
                                barWidth - barWidth * (health1 / 100.0), 10.0)
    }

    // left health bar
    love.graphics.setColor((255.0 - health2 * 2.55) / 255.0, 1.0, 0.0, 1.0)
    love.graphics.rectangle("fill", game.WIDTH / 2.0 - barWidth - 150.0, topOffset, barWidth, 10.0)

    if game.player2.health < 100 {
        love.graphics.setColor(224.0 / 255.0, (45.0 + health2) / 255.0,
                               (45.0 + health2) / 255.0, 1.0)
        love.graphics.rectangle("fill", (game.WIDTH / 2.0 - barWidth - 150.0), topOffset,
                                barWidth - barWidth * (health2 / 100.0), 10.0)
    }
}

fn drawForceAndAngle(game : &Game, which : Int, tempHack : Int) {
    let love = getLove()

    let px = if which == 1 { game.player1.x } else { game.player2.x }
    let py = if which == 1 { game.player1.y } else { game.player2.y }
    let force = if which == 1 { game.player1.force } else { game.player2.force }
    let angle = if which == 1 { game.player1.angle } else { game.player2.angle }
    mut xOffset = 0.0
    mut angleY = 0.0
    mut forceY = 0.0

    // different offset dep}ing on player
    if tempHack == 1 {
        xOffset = px - 140.0
        angleY = py + 80.0
        forceY = py + 92.0
    } else {
        xOffset = px + 55.0
        angleY = py + 78.0
        forceY = py + 90.0
    }

    // black background behind angle and force
    love.graphics.setColor(0.0, 0.0, 0.0, 0.7)
    love.graphics.rectangle_rounded("fill", xOffset + 12.0, angleY, 70.0, 13.0, 4.0, 4.0)
    love.graphics.rectangle_rounded("fill", xOffset + 24.0, forceY + 1.0, 66.0, 12.0, 4.0, 4.0)

    // print force (red)
    love.graphics.setColor(1.0, 0.0, 0.0, 1.0)
    love.graphics.setFont(game.assets.pixelFont) // size 20
    love.graphics.draw_text("GJ", xOffset + 76.0, forceY) // GigaJoules
    love.graphics.draw_text_aligned("{fmt_float(force, 5)}", xOffset, forceY, 75.0, "right")

    // print angle (white)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.draw_text_aligned("{fmt_float(360.0 - angle, 5)}", xOffset, angleY, 75.0, "right")
    love.graphics.ellipse("line", xOffset + 78.0, angleY + 3.0, 2.0, 2.0)
}

fn drawShips(game : &Game) {
    let love = getLove()

    // in the user interface (top left and top right)
    love.graphics.draw(game.assets.ss1, 24.0, 11.0)
    love.graphics.draw(game.assets.ss2, game.WIDTH - 32.0, 11.0)

    // love.graphics.setColor(1.0, 0.6, 0.6, 1.0)
    // love.graphics.ellipse("fill", player1.x, player1.y, 8.0, 8.0)
    // love.graphics.ellipse("fill", player2.x, player2.y, 8.0, 8.0)

    if game.player1.health > 0 {
        love.graphics.draw(game.assets.ss1, game.player1.x - 4.0, game.player1.y - 4.0)
    }

    if game.player2.health > 0 {
        love.graphics.draw(game.assets.ss2, game.player2.x - 4.0, game.player2.y - 4.0)
    }

    // love.graphics.draw(ss1, game.player1.x, game.player1.y, game.player1.angle, 1.0, 1.0, 4.0, 4.0)
}

// Dim all the shot trails on the screen
// meant to run after every shot
// works by drawing a black rectangle with low opacity over the whole screen
// then redraws all other elements on top
fn dimTrails(game : &Game) {
    let love = getLove()

    print("dimTrails EXECUTED")

    love.graphics.setCanvas(game.canvas)
    love.graphics.setColor(0.0, 0.0, 0.0, 0.15) // don't fortget to reset ?
    love.graphics.rectangle("fill", 0.0, 0.0, game.WIDTH, game.HEIGHT)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0) // reset back !?
    drawPlanets(game) // execute inside `canvas` ?!
    drawShips(game)
    drawUI(game)
    love.graphics.resetCanvas() // reset canvas ?!
}

fn drawPlanets(game : &Game) {
    let love = getLove()

    for planet in &game.allPlanets {
        love.graphics.setColor(0.1, 0.1, 0.1, 1.0)
        love.graphics.ellipse("fill", planet.x, planet.y,
                              planet.r, planet.r)
        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
        love.graphics.ellipse("line", planet.x, planet.y,
                              planet.r, planet.r)
    }
}
