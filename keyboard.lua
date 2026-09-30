// ----------------------------------------------------------------------------------------------------
// -- Code related to keyboard interactions
// ----------------------------------------------------------------------------------------------------
import types.{Game}
import shoot.{explode, playerPressedShootButton}
import logic.{newGame}

fn love_keypressed(game: &mut Game, key: String) {
    print(key)

    if key == "right" {
        game.keyRight = true
    }

    if key == "left" {
        game.keyLeft = true
    }

    if key == "up" {
        game.keyUp = true

        game.player1.force = game.player1.force * 1.01

    }

    if key == "down" {
        game.keyDown = true
    }

    if key == "x" {
        explode(game, 400.0, 300.0)
    }

    if key == "n" {
        newGame(game)
    }

    if key == "space" {
        playerPressedShootButton(game)
    }

    if key == "escape" {
        quit()
    }
}

fn love_keyreleased(game: &mut Game, key: String) {
    game.keyRight = false
    game.keyLeft = false
    game.keyUp = false
    game.keyDown = false
}
