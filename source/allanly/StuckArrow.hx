package allanly;

/**
 * Stuck Arrow
 * ALLAN, DANNY AND SULLY!
 * An arrow that sticks to an enemy.
 * 15/05/2021
 */
// Imports
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

// Dead arrows
class StuckArrow extends FlxSprite {
  private var parent:FlxObject;

  private var offsetX:Float;
  private var offsetY:Float;

  // Create arrow
  public function new(parent:FlxObject, x:Float, y:Float, angle:Float) {
    super(x, y, AssetPaths.arrow__png);
    this.angle = angle;
    this.parent = parent;

    // Calc offset
    offsetX = x - parent.x;
    offsetY = y - parent.y;
  }

  // Update arrow
  override public function update(elapsed:Float) {
    super.update(elapsed);

    if (parent == null || !parent.alive) {
      kill();
    }
    else {
      setPosition(parent.x + offsetX, parent.y + offsetY);
    }
  }
}
