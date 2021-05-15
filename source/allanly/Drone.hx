package allanly;

/**
 * Enemy
 * ALLAN AND SULLY!
 * This is the enemy, the archnemeis of our hero JIM!
 * 1/6/2015
 */
// Libraries
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

// Swinging enemies
class Drone extends Character {
  private static inline final MOVEMENT_SPEED_MAX:Float = 200;
  private static inline final MOVEMENT_SPEED_Y_MAX:Float = 2500;
  private static inline final MOVEMENT_SPEED_CHANGE:Float = 10;
  private static inline final MOVEMENT_SPEED_DECELERATION_CHANGE:Float = 0.2;
  private static inline final MOVEMENT_SPEED:Int = 200;

  // Pointer to jim
  private var jimPointer:Character;

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
    ignoreGravity = true;
    if (FlxG.keys.pressed.LEFT) {
      // Movement
      if (velocity.x > -MOVEMENT_SPEED_MAX) {
        // Less movement acceleration when jumping
        acceleration.x = -MOVEMENT_SPEED_CHANGE * (MOVEMENT_SPEED_MAX + velocity.x);
      }
      // Stop accelerating when we fast
      else if (velocity.x <= -MOVEMENT_SPEED_MAX) {
        acceleration.x = 0;
      }
    }

    if (FlxG.keys.pressed.RIGHT) {
      // Movement
      if (velocity.x < MOVEMENT_SPEED_MAX) {
        // Less movement acceleration when jumping

        acceleration.x = MOVEMENT_SPEED_CHANGE * (MOVEMENT_SPEED_MAX - velocity.x);
      }
      // Stop accelerating when we fast
      else if (velocity.x >= MOVEMENT_SPEED_MAX) {
        acceleration.x = 0;
      }
    }
    if (FlxG.keys.pressed.DOWN) {
      // Movement
      if (velocity.y < MOVEMENT_SPEED_Y_MAX) {
        // Less movement acceleration when jumping

        acceleration.y = MOVEMENT_SPEED_CHANGE * (MOVEMENT_SPEED_Y_MAX - velocity.y);
      }
      // Stop accelerating when we fast
      else if (velocity.y >= MOVEMENT_SPEED_Y_MAX) {
        acceleration.y = 0;
      }
    }
    if (FlxG.keys.pressed.UP) {
      // Movement
      if (velocity.y > -MOVEMENT_SPEED_Y_MAX) {
        // Less movement acceleration when jumping
        acceleration.y = -MOVEMENT_SPEED_CHANGE * (MOVEMENT_SPEED_Y_MAX + velocity.y);
      }
      // Stop accelerating when we fast
      else if (velocity.y <= -MOVEMENT_SPEED_Y_MAX) {
        acceleration.y = 0;
      }
    }

    if (!FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT) {
      // Stopped
      if (velocity.x < 5 && velocity.x > -5) {
        acceleration.x = 0;
        velocity.x = 0;
      }

      // Decelerating
      else if (velocity.x > 0) {
        acceleration.x = -MOVEMENT_SPEED_CHANGE * MOVEMENT_SPEED_DECELERATION_CHANGE * (MOVEMENT_SPEED_MAX + velocity.x);
      }
      else if (velocity.x < 0) {
        acceleration.x = MOVEMENT_SPEED_CHANGE * MOVEMENT_SPEED_DECELERATION_CHANGE * (MOVEMENT_SPEED_MAX - velocity.x);
      }
    }
    if (!FlxG.keys.pressed.UP && !FlxG.keys.pressed.DOWN) {
      // Stopped
      if (velocity.y < 5 && velocity.y > -5) {
        acceleration.y = 0;
        velocity.y = 0;
      }

      // Decelerating
      else if (velocity.y > 0) {
        acceleration.y = -MOVEMENT_SPEED_CHANGE * MOVEMENT_SPEED_DECELERATION_CHANGE * (MOVEMENT_SPEED_Y_MAX + velocity.y);
      }
      else if (velocity.y < 0) {
        acceleration.y = MOVEMENT_SPEED_CHANGE * MOVEMENT_SPEED_DECELERATION_CHANGE * (MOVEMENT_SPEED_Y_MAX - velocity.y);
      }
    }
    super.move(elapsed);
  }

  // Get hit
  public function getHit(velocity:Float) {
    health -= Math.abs(velocity / 10.0);
  }
}
