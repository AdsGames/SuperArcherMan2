package allanly;

/**
 * ALLAN AND SULLY!
 * Spawnpoint, where you come from and where you go
 * 4/6/2015
 */
// Libraries
import flixel.FlxSprite;

class Spawn extends FlxSprite {
  public function new(x:Float, y:Float, width:Float, height:Float) {
    // Construct parent
    super(x, y);

    // Images and animations
    loadGraphic(AssetPaths.horse__png, true, 44, 32);
    animation.add("eat", [0, 2, 1, 1, 1, 1, 2, 1, 1, 2, 2, 0], 3, false);
    animation.add("still", [0], 8, false);
    animation.play("still");
  }

  // Update
  override public function update(elapsed:Float) {
    super.update(elapsed);

    if (Tools.myRandom(0, 1000) == 1) {
      animation.play("eat");
    }
  }
}
