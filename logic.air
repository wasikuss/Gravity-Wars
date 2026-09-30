// ----------------------------------------------------------------------------------------------------
// -- Code related to creating new game, planets, collision check, and draw shot
// ----------------------------------------------------------------------------------------------------
import types.{Planet, Game, Player}
import ui.{drawPlanets, drawShips, drawUI}
import shoot.{explode}

fn newGame(game: &mut Game) {
    let love = getLove()

    setInitialPositions(game)

    game.player1.angle = 0.0
    game.player2.angle = 180.0

    game.player1.lastAngle = 0.0
    game.player2.lastAngle = 0.0

    game.player1.health = 100
    game.player2.health = 100

    love.graphics.setCanvas(game.canvas)
    love.graphics.clear(0.0, 0.0, 0.0, 0.0)
    drawPlanets(game)
    drawShips(game)
    drawUI(game)
    love.graphics.resetCanvas()

    print("New Game Started")
}


// Randomize placement of planets & ships
// check for overlap, retry if check fails
fn setInitialPositions(game: &mut Game) {

    print("randomizing planets attempt")

    game.allPlanets = [] // reset whatever we had before first

    // include parameters for max and min planet locations

    // TODO: experiment with mass
    // having the mass depend on radius is less fun - small planets stop mattering
    // mass = (math.pow(allPlanets[i].r,3)/25) -- MASS depends on radius^3 *** this affects speed of drawing

    for i in 0..game.numOfPlanets {
        push(&mut game.allPlanets, Planet {
            x: random_range(100.0, game.WIDTH - 100.0),
            y: random_range(150.0, game.HEIGHT - 250.0),
            r: random_range(15.0, 50.0),
            mass: random_range(10.0, 50.0) * 10.0,
        })
    }

    // reposition ships
    game.player1.x = random_range(200.0, game.WIDTH / 2.0 - 100.0)
    game.player1.y = random_range(200.0, game.HEIGHT - 200.0)
    game.player2.x = random_range(game.WIDTH / 2.0 + 100.0, game.WIDTH - 200.0)
    game.player2.y = random_range(200.0, game.HEIGHT - 200.0)

    // TODO - compute distance with square roots - not just x & y distance
    // check for planet overlap
    // check for ship overlapping with planet too
    // space them out by 50 px at least
    mut overlaps = false
    for planetA in &game.allPlanets {
        for planetB in &game.allPlanets {
            if planetA.x == planetB.x && planetA.y == planetB.y {
                // -- same planet, do nothing
            } else if abs(planetA.x - planetB.x) < 40.0 && abs(planetA.y - planetB.y) < 40.0 {
                overlaps = true
            } else if abs(planetA.x - game.player1.x) < 90.0 && abs(planetA.y - game.player1.y) < 90.0 {
                overlaps = true
            } else if abs(planetA.x - game.player2.x) < 90.0 && abs(planetA.y - game.player2.y) < 90.0 {
                overlaps = true
            }
        }
    }

    if overlaps {
        setInitialPositions(game)
    }
}

// check collisions with every shot that is drawn
// dims trails after every collision
fn collisonCheck(game: &mut Game, b: Int) {
    let love = getLove()

    // insert code that will set shotInProgress = false if all bullets are gone and end the turn with it

    // whenever the bullet hits the planet - remove from drawing & computing
    mut hitPlanet = false
    for planet in &game.allPlanets {
        let dx = planet.x - game.allBullets[b].x
        let dy = planet.y - game.allBullets[b].y

        if sqrt(dx * dx + dy * dy) < planet.r {

            // remove the bullet from the playing field
            // as long as it's placed outside the cutoff set in the drawShot()
            // it will not compute!!! no wasted CPU cycles!
            game.allBullets[b].x = 0.0
            game.allBullets[b].y = 0.0
            game.allBullets[b].vx = 0.0
            game.allBullets[b].vy = 0.0


            hitPlanet = true
        }
    }

    if hitPlanet {
        // this dims the trails on every collision -- probably should disable
        // dimTrails()
        love.graphics.setCanvas(game.canvas)
        drawPlanets(game) // draw planets because a collision overlaps with a planet :(
        love.graphics.resetCanvas()
    }

    // grace period when your bullet can't kill you
    if game.benign > 50 {
        didYouHitPlayer(game, 1, b)
        didYouHitPlayer(game, 2, b)
        if game.turn == 1 {
            updateHealthBar(game, 2, 1, b)
        } else {
            updateHealthBar(game, 1, 2, b)
        }
    }
}

// don't forget `b` the bullet index
fn didYouHitPlayer(game: &mut Game, which: Int, b: Int) {

    let px = if which == 1 { game.player1.x } else { game.player2.x }
    let py = if which == 1 { game.player1.y } else { game.player2.y }
    let dx = px - game.allBullets[b].x
    let dy = py - game.allBullets[b].y

    if sqrt(dx * dx + dy * dy) < 10.0 {
        print("you hit someone!")

        // only decrease 1 life!
        if game.endOfRound == false {
            if which == 1 { game.player1.lives = game.player1.lives - 1 } else { game.player2.lives = game.player2.lives - 1 }
        }
        game.endOfRound = true
        
        if which == 1 { game.player1.health = 0 } else { game.player2.health = 0 }
        
        // explode this location !!!
        explode(game, px, py)

        // hide player from the board
        if which == 1 {
            game.player1.x = -100.0
            game.player1.y = -100.0
        } else {
            game.player2.x = -100.0
            game.player2.y = -100.0
        }

        let lives = if which == 1 { game.player1.lives } else { game.player2.lives }
        if lives == 0 { print("GAME OVER, SOMEONE WON!") }
    }
}

// don't forget `b` the bullet index
fn updateHealthBar(game: &mut Game, playerNWhich: Int, opponentWhich: Int, b: Int) {
    let love = getLove()

    let px = if playerNWhich == 1 { game.player1.x } else { game.player2.x }
    let py = if playerNWhich == 1 { game.player1.y } else { game.player2.y }
    let dx = px - game.allBullets[b].x
    let dy = py - game.allBullets[b].y
    let distanceFromShot = sqrt(dx * dx + dy * dy)

    let opponentHealth = if opponentWhich == 1 { game.player1.health } else { game.player2.health }

    if float(opponentHealth) > distanceFromShot {
        if opponentWhich == 1 {
            game.player1.health = int(distanceFromShot)
        } else {
            game.player2.health = int(distanceFromShot)
        }
        love.graphics.setCanvas(game.canvas)
        drawUI(game)
        love.graphics.resetCanvas()
    }
}

// TODO: figure out a sensible default for resolution of the shot and speed of the shot
// warning: planets with all the small radii may allow bullets to pass through
//          because the shot rosolution is LOW

// TODO: allow shot to be outside the border by at least a little bit
// TODO: include code so it doesn't do the calculation if the shot is too far from border
//       if shot is within bounds of the screen, draw it


// THE MOST IMPORTANT FUNCTION - draws the lines for the shot "b" where b (think "bullet") is the shot name

// 1) if shot is outside some boundary, discard it
// 2) if the shot is outside drawing area, compute, but don't draw (TODO: this is not implemented yet)
// 3) if the shot is within screen:
//     a) compute x and y components from each planet on the current bullet (store in fpx & fpy variables)
//     b) sum up all the forces into a single vfx & vfy
//     c) add final force to bullet's initial force
//     d) draw the small segment
//     e) update bullet's 'initial' velocity for next iteration
fn drawShot(game: &mut Game, b : Int) {
    let love = getLove()

    // Variables involved:
    // b - bulletIndex `[b]`

    // (1)
    // set the shot outside if it hits outside the play border
    if game.allBullets[b].x > game.WIDTH - 10.0 || game.allBullets[b].x < 10.0 ||
        game.allBullets[b].y > game.WIDTH - 10.0 || game.allBullets[b].y < 10.0 {
        game.allBullets[b].x = 0.0
        game.allBullets[b].y = 0.0
    }

    // (3)
    // set the shot outside if it hits outside the play border
    if game.allBullets[b].x < game.WIDTH - 10.0 && game.allBullets[b].x > 10.0 &&
        game.allBullets[b].y < game.WIDTH - 10.0 && game.allBullets[b].y > 10.0 {

        mut vfx = 0.0
        mut vfy = 0.0

        // (a) + (b)
        // calculate force of planet on x1 and y1
        for planet in &game.allPlanets {
            let xDiff = planet.x - game.allBullets[b].x
            let yDiff = planet.y - game.allBullets[b].y
            let dist3 = pow(sqrt(xDiff * xDiff + yDiff * yDiff), 3.0)

            vfx = vfx + (xDiff / dist3) * planet.mass
            vfy = vfy + (yDiff / dist3) * planet.mass
        }

        // (c)
        // add initial velocity to the final velocity
        vfx = vfx + game.allBullets[b].vx
        vfy = vfy + game.allBullets[b].vy

        // set velocity of each bullet to its final velocity
        game.allBullets[b].vx = vfx
        game.allBullets[b].vy = vfy

        // (d)
        // Draw shot to canvas
        love.graphics.setCanvas(game.canvas)
        love.graphics.line(game.allBullets[b].x, game.allBullets[b].y,
                           game.allBullets[b].x + vfx, game.allBullets[b].y + vfy)
        love.graphics.resetCanvas()

        // (e)
        game.allBullets[b].x = game.allBullets[b].x + vfx
        game.allBullets[b].y = game.allBullets[b].y + vfy
    }
}
