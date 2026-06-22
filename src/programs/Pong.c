#include "../shell/os_bridge.h"
#include "../utils/stdio.h"
#include "./DIBmapReader.h"
#include "./FontWriter.h"
#include "../drivers/ScreenDriver.h"
#include "../utils/math.h"

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200

#define CHAR_ESC 0x1B
#define CHAR_W 0x77
#define CHAR_S 0x73

struct BallData {
    char color;
    int size;

    int x;  // x-position
    int y;  // y-position
    
    int vx; // x-velocity
    int vy; // y-velocity
};

struct PlayerData {
    int x; // x position of the player
    int y; // y position of the player

    int width;
    int height;

    int speed;
    
    int color;

    int score;
    int health;
    int gameover;
};

struct PlayerData player;
struct BallData ballData;

/**
 * Initializer function for the pong Singleplayer game.
 * 
 * @returns void
 */
void _initPong(void) {
    doubleBuffered(1);

    player.y = 100;
    player.x = 20;

    player.width = 6;
    player.height = 24;

    player.speed = 8;
    player.color = 0xFFFFFF;

    ballData.x = 150;
    ballData.y = 100;
    ballData.vx = 1;
    ballData.vy = 1;
    ballData.color = 0xFFFFFF;
    ballData.size = 4;

    player.health = 1;
    player.score = 0;
    player.gameover = 0;

    return;
}

/**
 * Stub function for the ISR event callback.
 * 
 * @returns void
 */
void noop(void) {
    return;
}

/**
 * Updates the position of the ball depending on it's velocity.
 * 
 * @returns void
 */
void _updateBall(void) {
    ballData.x += ballData.vx;
    ballData.y += ballData.vy;

    if (ballData.x <= ballData.size || ballData.x >= SCREEN_WIDTH) {
        ballData.x = ballData.size;
        ballData.vx = -ballData.vx;

        player.health--;
        _updateStats();

    } else if (ballData.x + ballData.size > SCREEN_WIDTH) {
        ballData.x = SCREEN_WIDTH - ballData.size;
        ballData.vx = -ballData.vx;
    }

    if (ballData.y <= ballData.size || ballData.y >= SCREEN_HEIGHT) {
        ballData.y = ballData.size;
        ballData.vy = -ballData.vy;

    } else if (ballData.y + ballData.size > SCREEN_HEIGHT) {
        ballData.y = SCREEN_HEIGHT - ballData.size;
        ballData.vy = -ballData.vy;
    }
}

/**
 * Renders the player's character.
 * 
 * @returns void
 */
void _renderPlayer(void) {
    drawRectangle(player.x, player.y, player.width, player.height, player.color);
}

/**
 * Renders the ball's character.
 * 
 * @returns void
 */
void _renderBall(void) {
    drawCircle(ballData.x, ballData.y, toFloat(ballData.size), ballData.color, 0);
}

/**
 * Updates the player's stats in the TTY.
 * 
 * @returns void
 */
void _updateStats(void) {
    ttyClearScreen();

    prints("Score: ", 0);
    printi(player.score, 1);

    prints("Health: ", 0);
    printi(player.health, 1);
    
    return;
}

// checks if the ball intersects with the player and updates the x velocity of the ball
/**
 * Checks if the ball intersects with the player's character.
 * Increases the score if it does, and reflects ball.
 * 
 * @returns void
 */
void _checkIntersection(void) {
    // just have to check the left-side of the ball as no second 
    // player exists in this version of pong

    if (ballData.x <= player.x + player.width && ballData.y >= player.y && ballData.y <= player.y + player.height) {
        ballData.vx = -ballData.vx;
        player.score++;
        _updateStats();
    }
}

/**
 * Dispatches a render for the new frame of the scene.
 * 
 * @returns void
 */
void _render(void) {
    clearScreen();

    // render player
    _renderPlayer();

    _renderBall();

    present();
}

/**
 * Updates the player's position based on the keyboard input.
 * 
 * @param ch movement character ("w" for up, "s" for down)
 * 
 * @returns void
 */
void _updatePlayer(char ch) {
    if (ch == CHAR_W) {
        player.y -= player.speed;
    } else if (ch == CHAR_S) {
        player.y += player.speed;
    }

    return;
}

/**
 * Gameover function.
 * 
 * @returns void
 */
void _gameover(void) {
    player.gameover = 1;

    char gameoverMsg[10] = "game over";
    renderText(gameoverMsg, 120, 100);

    present();

    return;
}

// used to ensure the ball isn't going crazy
int framecount = 0;

/**
 * Main game loop.
 * 
 * @return void
 */
void main(void) {
    char ch = ttyReadChar();
    
    if (ch == CHAR_ESC) {
        _end();
        return;
    }
    
    if (player.gameover) return;
    _updatePlayer(ch);
    
    if (framecount >= 60) {
        _updateBall();
        _checkIntersection();
        framecount = 0;
    }

    if (player.health == 0) {
        _gameover();
        return;
    }
    
    _render();
    
    framecount++;
}

/**
 * Ends the program, pops the process.
 * 
 * @returns void
 */
void _end(void) {
    doubleBuffered(0);
    clearScreen();
    popProc();
}

/**
 * Entry point for the game.
 */
void pong(int argc, int **argv) {
    _initPong();
    pushProc(main, noop);
}
