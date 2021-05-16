package allanly;

/**
 * Enemy
 * ALLAN AND SULLY!
 * This is the enemy, the archnemeis of our hero JIM!
 * 1/6/2015
 */
// Libraries
import flixel.FlxG;

// Swinging enemies
class Drone extends Character {
  private static inline final MOVEMENT_SPEED_MAX:Float = 200;
  private static inline final MOVEMENT_SPEED_Y_MAX:Float = 200;
  private static inline final MOVEMENT_SPEED_CHANGE_2:Float = 10;
  private static inline final MOVEMENT_SPEED_DECELERATION_CHANGE_2:Float = 0.2;
  private static inline final MOVEMENT_SPEED:Int = 200;

  // Pointer to jim
  private var jimPointer:Character;

  // Create enemy number 1 (public)
  public function new(x:Float, y:Float, jimPointer:Character) {
    // I'll control your abort
    super(x, y);

    // Init vars
    health = 1000;

    // Images and animations
    loadGraphic(AssetPaths.birbfly__png, true, 16, 16);
    animation.add("fly", [0, 1, 2, 3, 4, 5], 22, true);
    animation.add("idle", [0, 1, 2, 3, 4, 5], 5, true);
    animation.add("glide", [3], 0, true);

    animation.play("idle");

    this.acceleration.y = 0;
  }

  // Update
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Move enemy
    move(elapsed);
  }

  // Move around
  override public function move(elapsed:Float) {
    if (FlxG.keys.pressed.LEFT) {
      animation.play("fly");
      // Movement
      if (velocity.x > -MOVEMENT_SPEED_MAX) {
        // Less movement acceleration when jumping
        acceleration.x = -MOVEMENT_SPEED_CHANGE_2 * (MOVEMENT_SPEED_MAX + velocity.x);
      }
      // Stop accelerating when we fast
      else if (velocity.x <= -MOVEMENT_SPEED_MAX) {
        acceleration.x = 0;
      }
      if (scale.x < 0) {
        scale.x *= -1;
      }
    }

    if (FlxG.keys.pressed.RIGHT) {
      animation.play("fly");
      // Movement
      if (velocity.x < MOVEMENT_SPEED_MAX) {
        // Less movement acceleration when jumping
        acceleration.x = MOVEMENT_SPEED_CHANGE_2 * (MOVEMENT_SPEED_MAX - velocity.x);
      }
      // Stop accelerating when we fast
      else if (velocity.x >= MOVEMENT_SPEED_MAX) {
        acceleration.x = 0;
      }
      if (scale.x > 0) {
        scale.x *= -1;
      }
    }
    if (FlxG.keys.pressed.UP) {
      animation.play("fly");
      // Movement
      if (velocity.y > -MOVEMENT_SPEED_Y_MAX) {
        // Less movement acceleration when jumping
        acceleration.y = -MOVEMENT_SPEED_CHANGE_2 * (MOVEMENT_SPEED_Y_MAX + velocity.y);
      }
      // Stop accelerating when we fast
      else if (velocity.y <= -MOVEMENT_SPEED_Y_MAX) {
        acceleration.y = 0;
      }
    }
    if (FlxG.keys.pressed.DOWN) {
      animation.play("glide");
      // Movement
      if (velocity.y < MOVEMENT_SPEED_Y_MAX) {
        // Less movement acceleration when jumping

        acceleration.y = MOVEMENT_SPEED_CHANGE_2 * (MOVEMENT_SPEED_Y_MAX - velocity.y);
      }
      // Stop accelerating when we fast
      else if (velocity.y >= MOVEMENT_SPEED_Y_MAX) {
        acceleration.y = 0;
      }
    }
    if (!FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.UP && !FlxG.keys.pressed.DOWN)
      animation.play("idle");
    if (!FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT) {
      // Stopped
      // just like my heart should be
      if (velocity.x < 5 && velocity.x > -5) {
        acceleration.x = 0;
        velocity.x = 0;
      }

      // Decelerating
      else if (velocity.x > 0) {
        acceleration.x = -MOVEMENT_SPEED_CHANGE_2 * MOVEMENT_SPEED_DECELERATION_CHANGE_2 * (MOVEMENT_SPEED_MAX + velocity.x);
      }
      else if (velocity.x < 0) {
        acceleration.x = MOVEMENT_SPEED_CHANGE_2 * MOVEMENT_SPEED_DECELERATION_CHANGE_2 * (MOVEMENT_SPEED_MAX - velocity.x);
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
        acceleration.y = -MOVEMENT_SPEED_CHANGE_2 * MOVEMENT_SPEED_DECELERATION_CHANGE_2 * (MOVEMENT_SPEED_Y_MAX + velocity.y);
      }
      else if (velocity.y < 0) {
        acceleration.y = MOVEMENT_SPEED_CHANGE_2 * MOVEMENT_SPEED_DECELERATION_CHANGE_2 * (MOVEMENT_SPEED_Y_MAX - velocity.y);
      }
    }

    super.move(elapsed);
  }

  // Kill
  override public function kill() {
    super.kill();
    alive = false;
    exists = false;
  }

  public function getBow():Bow {
    return Std.downcast(getArm(), Bow);
  }

  // Get hit
  public function getHit(velocity:Float) {
    health -= Math.abs(velocity / 10.0);
  }
}
