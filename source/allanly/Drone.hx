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
class Drone extends Character {
  // Pointer to jim
  private var jimPointer:Character;

  // Constants
  private static inline final MOVEMENT_SPEED:Int = 200;

  // Create enemy
  public function new(jimPointer:Character) {
    super(jimPointer.getPosition().x, jimPointer.getPosition().y);

    // Init vars

    // Images and animations
    loadGraphic(AssetPaths.enemy__png, true, 14, 30);
    animation.add("idle", [4, 5, 6, 7], 5, true);
    animation.play("idle");

    // Player
    this.jimPointer = jimPointer;
  }

  // Update
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Move enemy
    move(elapsed);
  }

  // Move around
  override public function move(elapsed:Float) {
    super.move(elapsed);
  }

  // Get hit
  public function getHit(velocity:Float) {
    health -= Math.abs(velocity / 10.0);
  }
}
