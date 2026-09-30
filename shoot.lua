//--------------------------------------------------------------------------------------------------
// Code related to shooting bullets
//--------------------------------------------------------------------------------------------------
// this function sets the initial velocities for each bullet
// it doesn't shoot - it relies on the "drawShot" function to continue
//
// f - force            additional to player's chosen force,
// t - theta (angle)    additional to player's chosen angle,
// bulletIndex - index of the bullet
import types.{Bullet, Color, Game}
import ui.{drawUI, dimTrails}

fn setBulletInitialVelocity(game: &mut Game, mut f: Float, mut t: Float, bulletIndex: Int) {
    if game.turn == 1 {
        // preturb it by a bit for jitter so it's not the same
        f = game.player1.force + f // + math.random() * 2
        t = game.player1.angle + t // + math.random() * 10
    } else if game.turn == 2 {
        f = game.player2.force + f // + math.random() * 2
        t = game.player2.angle + t // + math.random() * 10
    }

    // *** REDUCE THE FORCE BY some amount and reduce weight of planets by some amount
    // *** this will make the resolution of the shot higher!!?! ***
    f = f / 2.0

    // calculate the x and y components of shot for initial force
    game.allBullets[bulletIndex].vx = f * cos(0.0174533 * t)
    game.allBullets[bulletIndex].vy = f * sin(0.0174533 * t)
}

fn newBullet(x: Float, y: Float) -> Bullet {
    Bullet {
        x, y, vx: 0.0, vy: 0.0, radius: 3.0,
        color: Color { r: 1.0, g: 1.0, b: 1.0, a: 1.0 }
    }
}

// to split a bullet (special bullet type allows for splitting while in air)
fn split(game: &mut Game, x : Float, y : Float) {
    let love = getLove()

    love.graphics.ellipse("line", x, y, 10.0, 10.0)

    // print("SPLIT @ ", x, y)

    for i in 0..3 {
        push(&mut game.allBullets, newBullet(x, y))
        let idx = game.numOfBullets + i
        setBulletInitialVelocity(game, 0.01, random_range(0.0, 360.0), idx)
    }

    game.numOfBullets = game.numOfBullets + 3
}

fn shoot(game : &mut Game, bulletType : Int) {
    if bulletType == 1 {
        game.numOfBullets = 1
    } else if bulletType == 2 {
        game.numOfBullets = 2
    } else if bulletType == 3 {
        game.numOfBullets = 5
    } else if bulletType == 4 {
        game.numOfBullets = 10
    }

    for i in 0..game.numOfBullets {
        push(&mut game.allBullets, newBullet(game.shipX, game.shipY))
        setBulletInitialVelocity(game, 1.0, 1.0, i)
    }
}

fn playerPressedShootButton(game : &mut Game) {
    let love = getLove()

    dimTrails(game)

    print("Whose is shooting? Player {game.turn}")

    // origin of the shot set to player's location
    if game.turn == 1 {
        game.shipX = game.player1.x
        game.shipY = game.player1.y
        game.player1.lastAngle = game.player1.angle
        game.player1.lastForce = game.player1.force
    } else if game.turn == 2 {
        game.shipX = game.player2.x
        game.shipY = game.player2.y
        game.player2.lastAngle = game.player2.angle
        game.player2.lastForce = game.player2.force
    }

    game.allBullets = [] // reset to empty

    // make bullet benign
    game.benign = 0

    shoot(game, game.bulType)

    love.graphics.setCanvas(game.canvas)
    drawUI(game)
    love.graphics.resetCanvas()

    game.shotInProgress = true
}

// blow up a location in a pretty way
fn explode(game : &mut Game, x : Float, y : Float) {
    let love = getLove()

    love.graphics.setCanvas(game.canvas)

    for i in 0..10 {
        let randX = random_range(-20.0, 20.0)
        let randY = random_range(-20.0, 20.0)
        let radius = random_range(5.0, 15.0)
        setExplodyColor()
        love.graphics.ellipse("fill", x + randX, y + randY, radius, radius)

        let bullet = Bullet { x: x + randX, y: y + randY, vx: 0.0, vy: 0.0, radius, color: Color { r: 1.0, g: 1.0, b: 1.0, a: 1.0 } }
        push(&mut game.allBullets, bullet)

        let idx = game.numOfBullets + i
        setBulletInitialVelocity(game, 1.0, random_range(0.0, 360.0), idx)
    }

    love.graphics.resetCanvas()

    game.numOfBullets = game.numOfBullets + 10
}

fn setExplodyColor() {
    let love = getLove()

    // red     1    0     0
    // orange  1    0.5   0
    // yellow  1    1     0

    love.graphics.setColor(1.0, random_range(0.0, 255.0) / 255.0, 0.0, 1.0)
}