package allanly;

/**
 * Door
 * ALLAN AND SULLY!
 * This is the enemy, the archnemeis of our hero JIM!
 * 3/6/2015
 */
// Libraries
import flixel.FlxSprite;

// Door (fun to kick in)
class Door extends FlxSprite {
  private var doorSpeed:Float;
  private var doorPosition:Float;
  private var open:Bool;

  // Create a nice one
  public function new(x:Float, y:Float) {
    super(x, y, AssetPaths.door__png);

    // Init vars
    doorSpeed = 0;
    doorPosition = 0;
    open = false;

    // Set orgin
    origin.x = 0;
    origin.y = 0;

    // Close the door
    scale.x = 0.2;

    // Cant move
    immovable = true;
  }

  // Update
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Slow down
    doorPosition += doorSpeed;
    doorSpeed /= 1.02;

    // Swinging
    scale.x = Math.sin(doorPosition) + 0.2;
  }

  // Open door
  public function hitDoor(magnitude:Float) {
    // Only move if its not already open
    if (scale.x < 0.6 && scale.x > -0.6) {
      doorSpeed = magnitude / 1000;
    }
  }
}
