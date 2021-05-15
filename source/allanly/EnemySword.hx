package allanly;

/**
 * Enemy
 * ALLAN AND SULLY!
 * This is the enemy, the archnemeis of our hero JIM!
 * 1/6/2015
 */
// Libraries
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

// Swinging enemies
class EnemySword extends Enemy {
  // Create enemy
  public function new(jimPointer:Character, name:String, x:Float = 0, y:Float = 0) {
    super(jimPointer, name, x, y);

    // Images and animations
    loadGraphic(AssetPaths.enemy__png, true, 14, 30);
    animation.add("walk", [0, 1, 2, 3], 10, true);
    animation.add("idle", [4, 5, 6, 7], 5, true);
    animation.play("idle");

    // Init health
    health = 100;
    movementSpeedMax = 180;
  }

  // Update
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Move enemy
    move(elapsed);
  }

  // Move around
  override public function move(elapsed:Float) {
    // Downcast sword
    var sword = Std.downcast(arm, Sword);

    // Move around
    if ((detected && x < jimPointer.x) || (patrolling && x < patrolPoints[patrolPointIndex].x)) {
      if (sword != null) {
        sword.setSpinDir("right");
      }

      moveRight();
    }
    else if ((detected && x > jimPointer.x) || (patrolling && x > patrolPoints[patrolPointIndex].x)) {
      if (sword != null) {
        sword.setSpinDir("left");
      }

      moveLeft();
    }
    else {
      if (sword != null) {
        sword.setSpinDir("none");
      }
      animation.play("idle");
    }

    // Move sword to self
    arm.setPosition(x, y);

    // Parent move
    super.move(elapsed);
  }
}
