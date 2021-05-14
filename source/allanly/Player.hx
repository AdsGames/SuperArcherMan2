package allanly;

/**
 * Player class
 * ALLAN AND SULLY!
 * Our main character, jim
 * 29/5/2015
 */
// Imports
import flixel.FlxG;
import flixel.group.FlxGroup;
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
  private static inline final MOVEMENT_SPEED:Float = 200;

  // Make character
  public function new(x:Float = 0, y:Float = 0) {
    // Create jim
    super(x, y);

    // Default values
    counter = 0;

    // Variables
    isOnLadder = false;
    ladderX = 0;
    dead = false;
    hasWon = false;

    // Images and animations
    loadGraphic(AssetPaths.player__png, true, 14, 30);
    animation.add("walk", [0, 1, 2, 3], 10, true);
    animation.add("idle", [4, 5, 6, 7], 5, true);
    animation.add("climb", [8, 9, 10, 11], 5, true);
    animation.add("die", [12, 13, 14, 15, 16], 5, false);
    animation.play("idle");

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

    // Move around
    move(elapsed);
  }

  // Move character
  override public function move(elapsed:Float) {
    ignoreGravity = isOnLadder;
    if (!dead) {
      // Move that character
      // Right
      if (FlxG.keys.pressed.D) {
        velocity.x = MOVEMENT_SPEED;
        animation.play("walk");
        // Flip
        if (scale.x < 0) {
          scale.x *= -1;
        }
      }
      // Left
      if (FlxG.keys.pressed.A) {
        velocity.x = -MOVEMENT_SPEED;
        animation.play("walk");
        // Flip
        if (scale.x > 0) {
          scale.x *= -1;
        }
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
      if (!FlxG.keys.pressed.A && !FlxG.keys.pressed.D && !isOnLadder) {
        animation.play("idle");
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

  // Get arrows
  public function getArrows():FlxGroup {
    var bow = Std.downcast(getArm(), Bow);
    if (bow != null) {
      return bow.getArrows();
    }
    return null;
  }

  // Die
  public function die() {
    if (!dead) {
      animation.play("die");
      arm.visible = false;
      dead = true;
      FlxG.sound.play(AssetPaths.bell__mp3);
      startTimer();
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
