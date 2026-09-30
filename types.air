struct Color {
    r : Float
    g : Float
    b : Float
    a : Float
}

struct Bullet {
    x : Float
    y : Float
    vx : Float
    vy : Float
    radius : Float
    color : Color
}

struct Planet {
    x : Float
    y : Float
    r : Float
    mass : Float
}

struct Player {
    x: Float
    y: Float
    angle: Float
    force: Float
    lives: Int
    health: Int
    lastAngle: Float
    lastForce: Float
}

struct Assets {
    ss1 : Image
    ss2 : Image
    pixelFont : Font
}

struct Game { x: Float,
    allPlanets: [Planet],
    allBullets: [Bullet],
    turn: Int,
    shotInProgress: Bool,
    dragging: Bool,
    draggingType: String,
    mouseXinitial: Float,
    mouseYinitial: Float,
    mouseXcurrent: Float,
    mouseYcurrent: Float,
    benign: Int,
    bulletsInFlight: Bool,
    endOfRound: Bool,
    colorMode: Int,
    bulType: Int,
    keyRight: Bool,
    keyLeft: Bool,
    keyUp: Bool,
    keyDown: Bool,
    rainbow: Color,
    assets: Assets,
    dragCursor : Cursor,
    canvas : Canvas,
    canvas2 : Canvas,
    numOfBullets: Int,
    numOfPlanets: Int,
    WIDTH: Float,
    HEIGHT: Float,
    player1: Player,
    player2: Player,
    shipX: Float,
    shipY: Float
}