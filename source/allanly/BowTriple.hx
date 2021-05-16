package allanly;

/*
 * Bow
 * ALLAN AND SULLY!
 * Our main character, jim's, bow
 * 29/5/2015
 */
// Imports
import flixel.math.FlxPoint;

class BowTriple extends Bow {
  // Create bow
  public function new(maxPower:Float, chargeTime:Float, minPower:Float, team:Team) {
    super(maxPower, chargeTime, minPower, team);

    loadGraphic(AssetPaths.bow_arm__png, true, 47, 24);
    animation.add("drawback", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 0, false);
    animation.play("drawback");
    scale.set(0.70, 0.70);

    origin = new FlxPoint(origin.x, 15);
  }

  // Change location
  override public function setPosition(x:Float = 0.0, y:Float = 0.0) {
    super.setPosition(x - 10, y - 5);
  }

  public override function release() {
    // Min velocity
    if (power > minPower) {
      Character.arrowContainer.add(new Arrow(this, x + origin.x, y + origin.y, angle, power, team));
      Character.arrowContainer.add(new Arrow(this, x + origin.x, y + origin.y, angle + 5, power, team));
      Character.arrowContainer.add(new Arrow(this, x + origin.x, y + origin.y, angle - 5, power, team));
      bowReleaseSound.play();
    }

    super.release();
  }
}
