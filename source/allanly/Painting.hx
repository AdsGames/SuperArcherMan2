package allanly;

/**
 * Snazzy animated paintint
 * ALLAN AND SULLY!
 * Nice painting
 * 11/6/2015
 */
// Libraries
import flixel.FlxSprite;

// Torch
class Painting extends FlxSprite {
  // Create
  public function new(x:Float, y:Float) {
    // Construct parent
    super(x, y);

    // Images and animations
    loadGraphic(AssetPaths.painting__png, true, 48, 32);
    animation.add("superBlink", [0, 1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 6, 5, 4, 3, 2, 1, 0], 8, false);
    animation.add("normal", [0], 8, true);
    animation.play("normal");
  }

  // Update
  override public function update(elapsed:Float) {
    super.update(elapsed);

    if (Tools.myRandom(0, 500) == 1) {
      animation.play("superBlink", true);
    }
  }
}
