package allanly;

/*
 * Bow
 * ALLAN AND SULLY!
 * Our main character, jim's, bow
 * 29/5/2015
 */
// Imports
import flixel.math.FlxPoint;

class BowShotgun extends Bow {
  // Create bow
  public function new(maxPower:Float, chargeTime:Float, minPower:Float, team:Team, ammo:Int) {
    super(maxPower, chargeTime, minPower, team, ammo);

    loadGraphic(AssetPaths.bow_arm_shotgun__png, true, 47, 24);
    animation.add("drawback", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 0, false);
    animation.play("drawback");
    scale.set(0.80, 0.80);

    name = "Shotbow";

    name = "Shotbow";

    origin = new FlxPoint(origin.x, 15);
  }

  // Change location
  override public function setPosition(x:Float = 0.0, y:Float = 0.0) {
    super.setPosition(x - 10, y - 5);
  }

  public override function release() {
    // Min velocity
    if (power > minPower) {
      for (_ in 0...15) {
        Character.arrowContainer.add(new Arrow(this, x + origin.x, y + origin.y, angle + Tools.myRandom(-10, 10), power, team));
      }

      bowReleaseSound.play();
      ammo -= 1;
    }

    super.release();
  }
}
