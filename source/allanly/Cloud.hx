package allanly;

/**
 * Cloud
 * ALLAN AND SULLY!
 * Animated torch for that castle feel
 * 11/6/2015
 */
// Libraries
import flixel.FlxG;
import flixel.FlxSprite;

class Cloud extends FlxSprite {
  // Create
  public function new(x:Float, y:Float) {
    // Construct parent
    super(x, y, AssetPaths.cloud__png);

    // Randomization
    velocity.x = Tools.myRandom(5, 20);
    scale.x = Tools.myRandom(5, 20) / 10;
    offset.y = Tools.myRandom(0, FlxG.camera.height);
  }

  // Update
  override public function update(elapsed:Float) {
    // Update parent
    super.update(elapsed);
    setPosition(x, FlxG.camera.y + 10);
  }
}
