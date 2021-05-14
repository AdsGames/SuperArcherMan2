package allanly;

/**
 * Ladder
 * ALLAN AND SULLY!
 * Ladder to get to higher (or lower) places
 * 4/6/2015
 */
// Libraries
import flixel.FlxSprite;

// Ladder to climb
class Ladder extends FlxSprite {
  public function new(x:Float, y:Float, width:Float, height:Float) {
    super(x, y);
    this.width = width;
    this.height = height;
  }
}
