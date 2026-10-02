package allanly;

/**
 * Tools
 * ALLAN AND SULLY
 * Tools for all classes
 * 14/6/2015
 */
import flixel.FlxG;
import flixel.math.FlxPoint;

class Tools {
  // Distance between 2 pts
  public static function getDistance(p1:FlxPoint, p2:FlxPoint):Float {
    var xx:Float = p2.x - p1.x;
    var yy:Float = p2.y - p1.y;
    return Math.sqrt(xx * xx + yy * yy);
  }

  // Random generator, min and max inclusive with equal odds
  public static function myRandom(min:Int, max:Int):Int {
    return FlxG.random.int(min, max);
  }

  // Random chance, true chance% of the time
  public static function randomChance(chance:Int):Bool {
    return FlxG.random.bool(chance);
  }
}
