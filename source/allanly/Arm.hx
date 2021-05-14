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
  // Create arm
  public function new(image:String = AssetPaths.sword_arm__png) {
    super(0, 0, image);
  }

  // Update bow
  override public function update(elapsed:Float) {
    super.update(elapsed);
  }
}
