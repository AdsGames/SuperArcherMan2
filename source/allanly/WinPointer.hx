package allanly;

/**
 * Win Pointer
 * ALLAN AND SULLY!
 * Points in direction of spawn
 * 31/01/2021
 */
// Libraries
import flixel.FlxSprite;
import flixel.math.FlxAngle;

class WinPointer extends FlxSprite {
  private var spriteToPoint:FlxSprite;
  private var player:Character;

  private static inline final ARROW_DIST:Int = 30;

  // Create
  public function new(spriteToPoint:FlxSprite, player:Character) {
    // Construct parent
    super(0, 0);

    this.spriteToPoint = spriteToPoint;
    this.player = player;

    // Images and animations
    loadGraphic(AssetPaths.win_arrow__png, true, 11, 11);
    animation.add("go", [5, 4, 3, 2, 1, 0], 8, true);
    animation.play("go");

    visible = false;
  }

  // Crown got
  public function enable() {
    visible = true;
  }

  public function setEnabled(newEnabled:Bool) {
    visible = newEnabled;
  }

  // Update
  override public function update(elapsed:Float) {
    super.update(elapsed);

    angle = FlxAngle.angleBetween(player, spriteToPoint, true);
    var angleRad = angle * FlxAngle.TO_RAD;
    x = player.x + ARROW_DIST * Math.cos(angleRad);
    y = player.y + ARROW_DIST * Math.sin(angleRad);
  }
}
