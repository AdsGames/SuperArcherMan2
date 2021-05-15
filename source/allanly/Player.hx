package allanly;

/**
 * Player class
 * ALLAN AND SULLY!
 * Our main character, jim
 * 29/5/2015
 */
// Imports
import Math;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class Player extends Character {
  // Timers
  private var counter:Int;

  // Variables
  private var isOnLadder:Bool;
  private var ladderX:Float;
  private var dead:Bool;
  private var hasWon:Bool;

  // Constants
  private static inline final JUMP_VELOCITY:Float = 250.0;
  private static inline final DEATH_TIMER:Float = 3;

  // Make character
  public function new(x:Float = 0, y:Float = 0) {
    // Create jim
    super(x, y);

    // Default values
    counter = 0;
    movementSpeedMax = 200;

    // Variables
    isOnLadder = false;
    ladderX = 0;
    dead = false;
    hasWon = false;

    // Init health
    health = 100;

    // Images and animations
    loadGraphic(AssetPaths.player__png, true, 23, 30);
    animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
    animation.add("idle", [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31], 5, true);
    animation.add("climb", [64, 65, 66, 67], 5, true);
    animation.add("die", [
      32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62
    ], 15, false);
    animation.play("idle");

    // BB Offset
    width = 16;
    offset.set(3, 0);

    // Say a little something on creation
    var randomSaying:Int = Tools.myRandom(0, 4);
    if (randomSaying == 1) {
      FlxG.sound.play(AssetPaths.jim_saying1__mp3);
    }
    else if (randomSaying == 2) {
      FlxG.sound.play(AssetPaths.jim_saying2__mp3);
    }
    else if (randomSaying == 3) {
      FlxG.sound.play(AssetPaths.jim_saying3__mp3);
    }
    else if (randomSaying == 4) {
      FlxG.sound.play(AssetPaths.jim_saying4__mp3);
    }
  }

  // Update
  override public function update(elapsed:Float) {
    // Update parent
    super.update(elapsed);

    // Kill urself
    if (!dead && FlxG.keys.pressed.K) {
      die();
    }

    // Update bow target
    var bow = Std.downcast(arm, Bow);
    bow.setTarget(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y));

    // Make arrows
    if (FlxG.mouse.justPressed) {
      bow.pullBack();
    }
    else if (FlxG.mouse.justReleased) {
      bow.release();
    }

    // Move around
    move(elapsed);
  }

  // Move character (keep out danny)
  override public function move(elapsed:Float) {
    ignoreGravity = isOnLadder;
    if (!dead) {
      // Move that character
      // Right
      if (FlxG.keys.pressed.D) {
        moveRight();
      }
      // Left
      if (FlxG.keys.pressed.A) {
        moveLeft();
      }
      // Ladder
      if (isOnLadder) {
        if (FlxG.keys.pressed.W) {
          animation.play("climb");
          y -= 1;
        }
        else if (FlxG.keys.pressed.S) {
          animation.play("climb");
          y += 1;
        }
      }
      // Jump Jump!
      if (FlxG.keys.pressed.SPACE) {
        jump(JUMP_VELOCITY);
      }
      // Idleing
      if (!FlxG.keys.pressed.A && !FlxG.keys.pressed.D) {
        // Stopped
        if (velocity.x < 5 && velocity.x > -5) {
          acceleration.x = 0;
          velocity.x = 0;

          // Resolve animation if we're on a ladder
          if (!isOnLadder) {
            animation.play("idle");
          }
          else {
            animation.play("climbing");
          }
        }

        // Decelerating
        else if (velocity.x > 0) {
          acceleration.x = -movementSpeedChange * MOVEMENT_SPEED_DECELERATION_CHANGE * (movementSpeedMax + velocity.x);

          // Resolve animation if we're on a ladder
          if (!isOnLadder) {
            animation.play("walk");
          }
          else {
            animation.play("climbing");
          }
        }
        else if (velocity.x < 0) {
          acceleration.x = movementSpeedChange * MOVEMENT_SPEED_DECELERATION_CHANGE * (movementSpeedMax - velocity.x);

          // Resolve animation if we're on a ladder
          if (!isOnLadder) {
            animation.play("walk");
          }
          else {
            animation.play("climbing");
          }
        }
      }

      // Win
      if (hasWon && counter >= DEATH_TIMER) {
        FlxG.sound.music.stop();
        counter = 0;
        FlxG.switchState(new MenuState());
      }
    }
    else if (dead && counter >= DEATH_TIMER) {
      FlxG.sound.music.stop();
      FlxG.switchState(new PlayState(PlayState.levelOn));
    }

    super.move(elapsed);
  }

  // Die
  public function die() {
    if (!dead) {
      animation.play("die");
      arm.visible = false;
      dead = true;
      FlxG.sound.play(AssetPaths.bell__mp3);
      startTimer();
      velocity.x = 0;
      acceleration.x = 0;
    }
  }

  // Win
  public function win() {
    if (!hasWon) {
      hasWon = true;
      FlxG.sound.play(AssetPaths.win__mp3);
      startTimer();
    }
  }

  // Ready to climb
  public function onLadder(isOnLadder:Bool) {
    this.isOnLadder = isOnLadder;

    if (isOnLadder) {
      if (FlxG.keys.pressed.W || FlxG.keys.pressed.S) {
        x = ladderX;
      }
    }
  }

  // Ready to climb
  public function ladderPosition(player:Player, ladder:Ladder) {
    ladderX = ladder.x;
  }

  // Start power timer
  private function startTimer() {
    counter = 0;
    new FlxTimer().start(1, incrementTimer, 0);
  }

  // Death timer
  private function incrementTimer(timer:FlxTimer) {
    counter++;
  }
}
