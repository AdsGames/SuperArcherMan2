package allanly;

/**
 * Background
 * ALLAN AND SULLY!
 * Background handler
 * 14/6/2015
 */
// Libraries
import flixel.FlxG;
import flixel.FlxSprite;

class Background extends FlxSprite {
  // Create
  public function new(width:Int) {
    super(0, 0, AssetPaths.mountains__png);

    // Add backgrounds
    var t:Int = 0;
    while (t < width) {
      var paralax:FlxSprite = new FlxSprite(t, 0, AssetPaths.mountains__png);
      paralax.scrollFactor.x = 0.5;
      FlxG.state.add(paralax);
      t += FlxG.width;
    }
  }
}
