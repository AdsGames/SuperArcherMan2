package allanly;

/**
 * Enemy
 * ALLAN AND SULLY!
 * This is the enemy, the archnemeis of our hero JIM!
 * 1/6/2015
 */
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

    // Long detect distance
    detectDistance = 200;

    // Init health
    health = 1000;
    healthBar.setRange(0, health);
    pickupArm(new BowBasic(1000.0, 1.0, 100.0, Team.ENEMY, 1000));
  }

  // Update
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Move enemy
    move(elapsed);

    // Downcast sword
    var bow = Std.downcast(arm, Bow);
    bow.setTarget(jimPointer.getPosition());

    // Shoot
    if (alive) {
      if (bow.getPower() == 0 && detected) {
        bow.pullBack();
      }
      if (bow.getPower() > 70 && Tools.randomChance(10)) {
        bow.release();
      }
    }

    // Move sword to self
    arm.setPosition(x, y);
  }

  // Move around
  override public function move(elapsed:Float) {
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

    // Parent move
    super.move(elapsed);
  }
}
