package allanly;

/*
 * Bow
 * ALLAN AND SULLY!
 * Our main character, jim's, bow
 * 29/5/2015
 */
// Imports
import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
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

  private var bowReleaseSound:FlxSound;
  private var charge1:FlxSound;
  private var charge2:FlxSound;
  private var charge3:FlxSound;

  // Emitter for charge VFX
  public var trailEmitter:FlxEmitter;

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

    bowReleaseSound = new FlxSound();
    bowReleaseSound.loadEmbedded(AssetPaths.bow_release__mp3);

    charge1 = new FlxSound();
    charge1.loadEmbedded(AssetPaths.charge1__wav);
    charge2 = new FlxSound();
    charge2.loadEmbedded(AssetPaths.charge2__wav);
    charge3 = new FlxSound();
    charge3.loadEmbedded(AssetPaths.charge3__wav);

    // Create emitter
    trailEmitter = new FlxEmitter(5, 5, 100);
    trailEmitter.loadParticles(AssetPaths.particle_star__png, 100);
    trailEmitter.scale.set(0.6, 0.6, 0.6, 0.6, 0, 0, 0, 0);
    trailEmitter.launchMode = FlxEmitterMode.CIRCLE;
    trailEmitter.speed.set(20, 20);
    trailEmitter.lifespan.set(0.6);
    trailEmitter.start(false, 0.01, 0);
    FlxG.state.add(trailEmitter);
    trailEmitter.emitting = false;

    // Default target
    target = new FlxPoint(0, 0);
  }

  // Update bow
  override public function update(elapsed:Float) {
    super.update(elapsed);

    trailEmitter.setPosition(x + width / 2, y + height / 2);

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

  // Ticker for bow power
  private function powerTicker(timer:FlxTimer) {
    power += maxPower / 100.0;

    // Frame for bow power state
    animation.frameIndex = Std.int((power / maxPower) * 15);

    // VFX for charge stats
    if (power / maxPower > 0.3 && power / maxPower < 0.40) {
      trailEmitter.emitting = true;
      charge1.play();
    }
    else if (power / maxPower > 0.6 && power / maxPower < 0.70) {
      trailEmitter.emitting = true;
      charge2.play();
    }
    else if (power / maxPower > 0.9) {
      trailEmitter.emitting = true;
      charge3.play();
    }
    else {
      trailEmitter.emitting = false;
    }

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

  public function release(team:Int) {
    var arrow:Arrow = null;

    // Min velocity
    if (power > minPower) {
      arrow = new Arrow(this, x + origin.x, y + origin.y, angle, power, team);
      bowReleaseSound.play();
    }

    animation.frameIndex = 0;
    trailEmitter.emitting = false;
    stopSound();

    power = 0;
    powerTimer.cancel();

    return arrow;
  }

  public function stopSound() {
    charge1.stop();
    charge2.stop();
    charge3.stop();
  }
}
