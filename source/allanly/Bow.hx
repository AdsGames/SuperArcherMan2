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
  private var team:Team;

  private var bowReleaseSound:FlxSound;
  private var charge1:FlxSound;
  private var charge2:FlxSound;
  private var charge3:FlxSound;

  // Emitter for charge VFX
  public var trailEmitter:FlxEmitter;

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

  // Ticker for bow power
  private function powerTicker(timer:FlxTimer) {
    power += maxPower * (timer.elapsedTime / chargeTime);

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
    powerTimer.start(0.01, powerTicker, 0);
    animation.play("drawback");
  }

  public function release() {
    animation.frameIndex = 0;
    trailEmitter.emitting = false;
    stopSound();

    power = 0;
    powerTimer.cancel();
  }

  public function stopSound() {
    charge1.stop();
    charge2.stop();
    charge3.stop();
  }
}
