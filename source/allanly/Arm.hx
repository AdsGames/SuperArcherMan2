package allanly;

/**
 * Arm
 * ALLAN AND SULLY!
 * Arm for players
 * 3/6/2015
 */
// Imports
import flixel.FlxSprite;

// Arm that attatches to player
class Arm extends FlxSprite {
  private var name:String;

  // Create arm
  public function new(image:String = AssetPaths.sword_arm__png) {
    super(0, 0, image);
    name = "Arm";
  }

  // Update bow
  override public function update(elapsed:Float) {
    super.update(elapsed);
  }

  public function getName() {
    return name;
  }
}
