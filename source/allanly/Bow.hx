package allanly;

/*
 * Bow
 * ALLAN AND SULLY!
 * Our main character, jim's, bow
 * 29/5/2015
 */
// Imports
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class Bow extends Arm {
  // Variables
  private var maxPower:Float;
  private var chargeTime:Float;
  private var minPower:Float;

  // Container of arrows
  private var arrowContainer:FlxTypedGroup<Arrow>;

  // Variables
  private var powerTimer:FlxTimer;
  private var power:Float;

  private var target:FlxPoint;

  // Create bow
  public function new(maxPower:Float = 100.0, chargeTime:Float = 1.0, minPower:Float = 20.0) {
    super();

    loadGraphic(AssetPaths.bow_arm__png, true, 47, 24);
    animation.add("drawback", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 0, false);
    animation.play("drawback");
    scale.set(0.65, 0.65);

    // Init vars
    power = 0;
    powerTimer = new FlxTimer();

    // Set max power it can shoot with
    this.maxPower = maxPower;
    this.chargeTime = chargeTime;
    this.minPower = minPower;

    origin = new FlxPoint(width / 2, 15);

    // Arrow container
    arrowContainer = new FlxTypedGroup<Arrow>();
    FlxG.state.add(arrowContainer);

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

  // Change location
  override public function setPosition(x:Float = 0.0, y:Float = 0.0) {
    super.setPosition(x - 10, y - 5);
  }

  // Return arrows
  public function getArrows():FlxTypedGroup<Arrow> {
    return arrowContainer;
  }

  // Ticker for bow power
  private function powerTicker(timer:FlxTimer) {
    power += maxPower / 100.0;

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
    powerTimer.start(chargeTime / 100.0, powerTicker, 0);
    animation.play("drawback");
  }

  public function release() {
    // Min velocity
    if (power > minPower) {
      arrowContainer.add(new Arrow(this, x + origin.x, y + origin.y, angle, power, 8));
    }
    animation.frameIndex = 0;
    power = 0;
    powerTimer.cancel();
  }
}
