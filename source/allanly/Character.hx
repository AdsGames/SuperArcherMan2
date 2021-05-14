package allanly;

/**
 * Character
 * Allan and Sully!
 * Top level character class
 * 29/5/2015
 */
import flixel.FlxG;
import flixel.FlxSprite;

class Character extends FlxSprite {
  // Variables
  private var jumping:Bool;
  private var ignoreGravity:Bool;

  // Weapon
  private var arm:Arm;

  // Acceleration (1m = 16px, gravity acceleration = 9.8m/s)
  private static inline final GRAVITY:Float = 9.8 * 16 * 4;

  // Make character
  public function new(x:Float, y:Float) {
    super(x, y);

    // Init vars
    jumping = false;
    ignoreGravity = false;

    // Add blank arm
    arm = new Arm();

    // Gravity
    acceleration.y = GRAVITY;
  }

  // Move character
  public function move(elapsed:Float) {
    // Put back in place
    if (x < 0) {
      x = 0;
    }
    if (y < 0) {
      y = 0;
    }

    // Move bow to player
    arm.setPosition(x, y);
  }

  // Update
  override public function update(elapsed:Float) {
    // Velocity from falling
    if (ignoreGravity) {
      velocity.y = 0;
    }

    // Jump
    if (velocity.y == 0) {
      jumping = false;
    }

    // Reduce x velocity
    if (velocity.x != 0) {
      velocity.x /= 2;
    }

    super.update(elapsed);
  }

  // Add arm
  public function pickupArm(arm:Arm) {
    FlxG.state.remove(arm);
    this.arm = arm;
    FlxG.state.add(arm);
  }

  // Get arm
  public function getArm():Arm {
    return arm;
  }

  // Jump
  public function jump(magnitude:Float) {
    if (!jumping && !ignoreGravity) {
      y -= 4;
      velocity.y = -magnitude;
      jumping = true;
    }
  }
}
