package allanly;

/*
 * Bow
 * ALLAN AND SULLY!
 * Our main character, jim's, bow
 * 29/5/2015
 */
// Imports
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

class Bow extends Arm {
  // Variables
  private var maxPower:Float;
  private var chargeTime:Float;
  private var minPower:Float;

  // Variables
  private var powerTimer:FlxTimer;
  private var power:Float;
  private var target:FlxPoint;
  private var team:Team;

  private var bowReleaseSound:FlxSound;

  // Create bow
  public function new(maxPower:Float, chargeTime:Float, minPower:Float, team:Team) {
    super();

    // Init vars
    power = 0;
    powerTimer = new FlxTimer();

    // Set max power it can shoot with
    this.maxPower = maxPower;
    this.chargeTime = chargeTime;
    this.minPower = minPower;
    this.team = team;

    bowReleaseSound = new FlxSound();
    bowReleaseSound.loadEmbedded(AssetPaths.bow_release__mp3);

    // Default target
    target = new FlxPoint(0, 0);
  }

  // Update bow
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Rotate
    angle = FlxAngle.angleBetweenPoint(this, target, true) + 90;
  }

  // Get power
  public function getPower():Int {
    return Math.round(power * 100.0 / maxPower);
  }

  // Ticker for bow power
  private function powerTicker(timer:FlxTimer) {
    power += maxPower * (timer.elapsedTime / chargeTime);

    // Frame for bow power state
    animation.frameIndex = Std.int((power / maxPower) * 15);

    // Keep in bounds
    if (power > maxPower) {
      power = maxPower;
    }
  }

  public function setTarget(point:FlxPoint) {
    target = point;
  }

  public function pullBack() {
    powerTimer.start(0.01, powerTicker, 0);
    animation.play("drawback");
  }

  public function release() {
    animation.frameIndex = 0;
    power = 0;
    powerTimer.cancel();
  }
}
