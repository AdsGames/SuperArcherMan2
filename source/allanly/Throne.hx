package allanly;

/**
 * Throne
 * ALLAN AND SULLY!
 * Nice throne
 * 11/6/2015
 */
// Libraries
import flixel.FlxSprite;

class Throne extends FlxSprite {
  public function new(x:Float, y:Float) {
    // Construct parent
    super(x, y, AssetPaths.throne__png);
  }
}
