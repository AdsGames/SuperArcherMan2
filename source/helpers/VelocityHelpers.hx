package helpers;

import flixel.math.FlxPoint;

class VelocityHelpers {
  public static function getTotalVelocity(velocity:FlxPoint) {
    return Math.sqrt(Math.pow(velocity.x, 2) + Math.pow(velocity.y, 2));
  }
}
