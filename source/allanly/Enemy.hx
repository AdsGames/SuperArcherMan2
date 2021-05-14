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
class Enemy extends Character {
  private var heySound:FlxSound;

  // Variables
  private var detected:Bool;

  // Pointer to jim
  private var jimPointer:Character;

  // Constants
  private static inline final MOVEMENT_SPEED:Int = 200;

  // Create enemy
  public function new(jimPointer:Character, x:Float = 0, y:Float = 0) {
    super(x, y - 40);

    // Init vars
    detected = false;

    // Images and animations
    loadGraphic(AssetPaths.enemy__png, true, 14, 30);
    animation.add("walk", [0, 1, 2, 3], 10, true);
    animation.add("idle", [4, 5, 6, 7], 5, true);
    animation.play("idle");

    // Player
    this.jimPointer = jimPointer;

    // Init health
    health = 10;

    // Load sounds
    heySound = new FlxSound();
    heySound.loadEmbedded(AssetPaths.enemy_hey__mp3);
  }

  // Update
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Update sound
    heySound.update(elapsed);

    // Move enemy
    move(elapsed);
  }

  // Move around
  override public function move(elapsed:Float) {
    // Detection
    var distance = Tools.getDistance(new FlxPoint(x, y), new FlxPoint(jimPointer.x, jimPointer.y));
    if (!detected && distance < 50 && health > 0) {
      detected = true;

      // Hey! sound
      heySound.proximity(x, y, jimPointer, 800, true);
      heySound.play();
    }

    // Downcast sword
    var sword = Std.downcast(arm, Sword);

    if (detected && x < jimPointer.x) {
      if (sword != null) {
        sword.setSpinDir("right");
      }
      velocity.x = MOVEMENT_SPEED;
      animation.play("walk");

      // Flip
      if (scale.x < 0) {
        scale.x *= -1;
      }
    }
    else if (detected && x > jimPointer.x) {
      if (sword != null) {
        sword.setSpinDir("left");
      }
      velocity.x = -MOVEMENT_SPEED;
      animation.play("walk");
      // Flip
      if (scale.x > 0) {
        scale.x *= -1;
      }
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

  // Get hit
  public function getHit(velocity:Float) {
    health -= Math.abs(velocity);
  }
}
