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
  private var chainSaw:FlxSound;
  private var chainSaw2:FlxSound;
  private var woosh:FlxSound;
  private var chainSawTimer:Float;
  private var chainSawCount:Int;
  private var chainSawRand:Int;

  // Create enemy
  public function new(jimPointer:Character, name:String, x:Float = 0, y:Float = 0) {
    super(jimPointer, name, x, y);

    chainSaw = new FlxSound();
    chainSaw.loadEmbedded(AssetPaths.chainSaw__wav);
    chainSaw2 = new FlxSound();
    chainSaw2.loadEmbedded(AssetPaths.chainSaw2__wav);
    woosh = new FlxSound();
    woosh.loadEmbedded(AssetPaths.woosh__wav);

    // Images and animations
    loadGraphic(AssetPaths.enemy__png, true, 14, 30);
    animation.add("walk", [0, 1, 2, 3], 10, true);
    animation.add("idle", [4, 5, 6, 7], 5, true);
    animation.play("idle");

    chainSawTimer = 100;
    chainSawCount = 0;

    // Init health
    health = 1000;
    movementSpeedMax = 100;
    movementSpeedChange = 2;
    healthBar.setRange(0, health);
  }

  // Update
  override public function update(elapsed:Float) {
    if (!alive) {
      return;
    }

    super.update(elapsed);

    // Play chainsaws noise
    if (chainSawCount >= chainSawTimer) {
      chainSaw.stop();
      chainSaw2.stop();
      woosh.stop();
      if (detected) {
        chainSawRand = Tools.myRandom(0, 1);
        if (chainSawRand == 0) {
          chainSaw.play();
          chainSaw.update(elapsed);
          chainSaw.proximity(x, y, jimPointer, 500, true);
        }
        else if (chainSawRand == 1) {
          chainSaw2.play();
          chainSaw2.update(elapsed);
          chainSaw2.proximity(x, y, jimPointer, 500, true);
        }
      }
      else {
        woosh.play();
        woosh.update(elapsed);
        woosh.proximity(x, y, jimPointer, 500, true);
      }
      chainSawCount = 0;
    }
    chainSawCount++;

    // Move enemy
    move(elapsed);
  }

  override public function detectPlayer() {
    movementSpeedMax = 240;
    velocity.x = 0;
    super.detectPlayer();
  }

  // Move around
  override public function move(elapsed:Float) {
    // Downcast sword
    var sword = Std.downcast(arm, Sword);
    if (!detected)
      chainSawTimer = 10000 * (1 / (Math.abs(velocity.x) + 100));
    else {
      chainSawTimer = 1000 * (1 / (Math.abs(velocity.x) + 100));
    }

    // Move around
    if ((detected && x < jimPointer.x) || (patrolling && x < patrolPoints[patrolPointIndex].x)) {
      if (sword != null) {
        sword.setSpinDir("right", velocity.x / 40);
        if (detected) {
          sword.setSpinDir("right", velocity.x / 3);
        }
      }
      moveRight();
    }
    else if ((detected && x > jimPointer.x) || (patrolling && x > patrolPoints[patrolPointIndex].x)) {
      if (sword != null) {
        sword.setSpinDir("left", velocity.x / 25);
        if (detected) {
          sword.setSpinDir("left", velocity.x / 5);
        }
      }
      moveLeft();
    }
    else {
      if (sword != null) {
        sword.setSpinDir("none", 0);
      }
      animation.play("idle");
    }

    // Move sword to self
    arm.setPosition(x, y);

    // Parent move
    super.move(elapsed);
  }
}
