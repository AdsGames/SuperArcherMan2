package allanly;

/**
 * Enemy
 * ALLAN AND SULLY!
 * This is the enemy, the archnemeis of our hero JIM!
 * 1/6/2015
 */
// Libraries
import flixel.math.FlxRandom;

// Swinging enemies
class EnemyArcher extends Enemy {
  // Create enemy
  public function new(jimPointer:Character, name:String, x:Float = 0, y:Float = 0) {
    super(jimPointer, name, x, y);

    movementSpeedMax = 60;

    // Images and animations
    loadGraphic(AssetPaths.enemy_archer__png, true, 14, 30);
    animation.add("walk", [0, 1, 2, 3], 10, true);
    animation.add("idle", [4, 5, 6, 7], 5, true);
    animation.play("idle");

    // Init health
    health = 100;
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
    var bow = Std.downcast(arm, Bow);

    bow.setTarget(jimPointer.getPosition());

    // Move around
    if ((detected && x < jimPointer.x) || (patrolling && x < patrolPoints[patrolPointIndex].x)) {
      moveRight();
    }
    else if ((detected && x > jimPointer.x) || (patrolling && x > patrolPoints[patrolPointIndex].x)) {
      moveLeft();
    }
    else {
      animation.play("idle");
    }

    if (bow.getPower() == 0) {
      bow.pullBack();
    }
    if (bow.getPower() > 70 && (new FlxRandom()).bool(10)) {
      var arrow = bow.release(1);
      if (arrow != null) {
        Character.arrowContainer.add(arrow);
      }
    }

    // Move sword to self
    arm.setPosition(x, y);

    // Parent move
    super.move(elapsed);
  }
}
