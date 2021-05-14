package allanly;

/**
 * Water
 * ALLAN AND SULLY!
 * Water effects
 * 12/6/2015
 */
import flixel.FlxSprite;

class Water extends FlxSprite {
  // Create the water
  public function new(x:Float, y:Float, width:Int, height:Int) {
    super(x, y + 8);

    makeGraphic(width, height, 0xFF0000FF);
  }
}
