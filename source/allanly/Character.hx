package allanly;

/**
 * Character
 * Allan and Sully!
 * Top level character class
 * 29/5/2015
 */
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxSound;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import haxe.Log;
import js.html.AbortController;

class Character extends FlxSprite {
  // Variables
  private var jumping:Bool;
  private var ignoreGravity:Bool;

  // Weapon
  private var arm:Arm;

  // Health bar
  private var healthBar:FlxBar;

  // Acceleration (1m = 16px, gravity acceleration = 9.8m/s)
  private static inline final GRAVITY:Float = 9.8 * 16 * 4;

  // Particle Emitter for blood
  public var bloodEmitter:FlxEmitter;

  // Hit sound
  public var hitSound:FlxSound;

  // Make character
  public function new(x:Float, y:Float) {
    super(x, y);

    // Init vars
    jumping = false;
    ignoreGravity = false;

    // Add blank arm
    arm = new Arm();

    // Create emitter
    bloodEmitter = new FlxEmitter(5, 5, 100);
    bloodEmitter.makeParticles(2, 2, FlxColor.fromRGB(100, 0, 0, 255), 100);
    bloodEmitter.launchMode = FlxEmitterMode.CIRCLE;
    bloodEmitter.speed.set(50, 80);
    bloodEmitter.lifespan.set(0.3);
    FlxG.state.add(bloodEmitter);

    // Hit sound
    hitSound = new FlxSound();
    hitSound.loadEmbedded(AssetPaths.flesh_hit__mp3);

    // Gravity
    acceleration.y = GRAVITY;

    // Health bar
    healthBar = new FlxBar(x, y, LEFT_TO_RIGHT, 26, 4, this, "health", 0, 100);
    FlxG.state.add(healthBar);
  }

  // Move character
  public function move(elapsed:Float) {
    // Put back in place
    if (x < 0) {
      x = 0;
    }
    if (y < 0) {
      y = 0;
    }

    // Move bow to player
    arm.setPosition(x, y);
  }

  // Update
  override public function update(elapsed:Float) {
    // Velocity from falling
    if (ignoreGravity) {
      velocity.y = 0;
    }

    // Jump
    if (velocity.y == 0) {
      jumping = false;
    }

    // Move blood emitter to sprite center
    bloodEmitter.setPosition(x + width / 2, y + height / 2);

    // Move health bar above sprite
    var barX = x + width / 2 - healthBar.barWidth / 2;
    var barY = y - healthBar.barHeight / 2 - 10;
    healthBar.setPosition(barX, barY);

    super.update(elapsed);
  }

  // On hit
  public function takeDamage(amount:Float, angleBetween:Float) {
    health -= amount;
    Log.trace(angleBetween);
    bloodEmitter.launchAngle.set(angleBetween - 25, angleBetween + 25);
    bloodEmitter.start(true, 0, 20);

    hitSound.volume = 0.1;
    hitSound.play();
  }

  // Add arm
  public function pickupArm(arm:Arm) {
    FlxG.state.remove(arm);
    this.arm = arm;
    FlxG.state.add(arm);
  }

  // Get arm
  public function getArm():Arm {
    return arm;
  }

  // Jump
  public function jump(magnitude:Float) {
    if (!jumping && !ignoreGravity) {
      y -= 4;
      velocity.y = -magnitude;
      jumping = true;
    }
  }
}
