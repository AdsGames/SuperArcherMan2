package allanly;

/**
 * Crown
 * ALLAN AND SULLY!
 * Animated tree for that nature feel
 * 4/6/2015
 */
// Libraries
import flixel.FlxG;
import flixel.FlxSprite;

class Crown extends FlxSprite {
  // Image
  private var taken:Bool;

  // Create
  public function new(x:Float, y:Float) {
    // Construct parent
    super(x, y);

    // Init vars
    taken = false;

    // Images and animations
    loadGraphic(AssetPaths.crown__png, true, 16, 32);
    animation.add("twinkle", [0, 1, 2, 3], 8, true);
    animation.add("gone", [4], 8, false);
    animation.play("twinkle");
  }

  // Its stolen!
  public function takeCrown() {
    if (!taken) {
      animation.play("gone");
      FlxG.sound.play(AssetPaths.crown_get__mp3, 0.5);
      taken = true;
    }
  }

  // Is it gone??
  public function isTaken():Bool {
    return taken;
  }
}
