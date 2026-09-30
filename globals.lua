// ----------------------------------------------------------------------------------------------------
// -- Code setting up all the global variables to be used
// ----------------------------------------------------------------------------------------------------
import types.{Player, Color, Game, Assets}

fn loadExternalAssets() -> Assets {
    let love = getLove()

    Assets {
        ss1: love.graphics.newImage("assets/ss1.png"),
        ss2: love.graphics.newImage("assets/ss2.png"),
        pixelFont: love.graphics.newFont("assets/basis33.ttf", 16.0)
    }
}

fn setVariables(game : &mut Game) {
    let love = getLove()

    game.dragCursor = love.mouse.getSystemCursor("sizewe")

    game.WIDTH = 1000.0
    game.HEIGHT = 800.0

    //-- Mouse click interactions
    game.dragging = false
    game.draggingType = "force" // `force` or `angle`
    game.mouseXinitial = 0.0
    game.mouseXcurrent = 0.0

    // FUN kaleidoscope time!
    // game.colorMode = 1

    // bullet type (should be changeable by player)
    game.bulType = 1

    // set number of bullets
    game.numOfBullets = 10

    // set number of Planets
    game.numOfPlanets = 7

    game.allPlanets = [] // each planet will have `mass`, `r`, `x`, `y`

    game.allBullets = [] // list of bullets, each will have `x`, `y`, and `vx`, `vy` (velocity x & y components)

    game.player1 = Player {
        x: 100.0
        y: 100.0
        angle: 0.0
        force: 1.5
        lives: 3
        health: 100
        lastAngle: 0.0
        lastForce: 0.0
    }

    game.player2 = Player {
        x: 500.0
        y: 500.0
        angle: 180.0
        force: 1.5
        lives: 3
        health: 100
        lastAngle: 0.0
        lastForce: 0.0
    }

    // whose turn
    game.turn = 1

    // used to end the turn sometime
    game.shotInProgress = false

    // integer to provide time-out so your bullet doesn't kill you in the first 50 iterations
    // benign while it's less than 50 iterations of bullet flight, for example (see collision check)
    game.benign = 0

    // if end of round = 1 it restarts the game after all the bullets end their path
    game.endOfRound = false

    // kaleidoscope mode colors for shot trails
    game.rainbow = Color { r: 1.0, g: 1.0, b: 1.0, a: 1.0 }

}
