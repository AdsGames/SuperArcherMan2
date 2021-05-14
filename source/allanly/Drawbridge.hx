package allanly;

/**
 * Drawbridge
 * ALLAN AND SULLY!
 * A drawbridge that opens with crank
 * 11/6/2015
 */
// Libraries
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

// Torch
class Drawbridge extends FlxSprite {
  // Timers
  private var fallTimer:FlxTimer;

  // Create
  public function new(x:Float, y:Float, width:Float, height:Float) {
    // Construct parent
    super(x, y, AssetPaths.drawbridge__png);

    this.width = width;
    this.height = height;

    origin.x = this.width / 2;
    origin.y = this.height - this.width / 2;

    immovable = true;

    fallTimer = new FlxTimer();

    solid = true;
  }

  // Spin for test
  override public function update(elapsed:Float) {
    super.update(elapsed);
  }

  // Turn crank
  public function fall() {
    fallTimer.start(0.1, fallDown, 0);
    FlxG.sound.play(AssetPaths.bridge__mp3);
  }

  // Turn crank
  public function fallDown(timer:FlxTimer) {
    if (angle > -90) {
      angle -= 5;
      FlxG.camera.shake(0.01, 0.4);
    }
    else {
      angle = -90;

      // For collision
      x -= height - width;
      y += height - width;

      offset.x -= height - width;
      offset.y += height - width;

      var oldWidth:Float = width;
      width = height;
      height = oldWidth;

      fallTimer.cancel();
    }
  }
}
