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
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

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

  // Movement vars
  private var movementSpeedMax:Float = 200;
  private var movementSpeedChange:Float = 10;

  // Movement consts
  private final MOVEMENT_SPEED_JUMPING_CHANGE:Float = 0.2;
  private final MOVEMENT_SPEED_DECELERATION_CHANGE:Float = 0.2;

  // Container of arrows
  public static var arrowContainer:FlxTypedGroup<Arrow> = null;

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
    bloodEmitter.speed.set(50 + velocity.x, 80 + velocity.y);
    bloodEmitter.lifespan.set(0.3);
    FlxG.state.add(bloodEmitter);

    // Hit sound
    hitSound = new FlxSound();
    hitSound.loadEmbedded(AssetPaths.flesh_hit__mp3);

    // Gravity
    acceleration.y = GRAVITY;

    // Health bar
    healthBar = new FlxBar(x, y, LEFT_TO_RIGHT, 26, 4, this, "health", 0, health);
    FlxG.state.add(healthBar);
  }

  // Move character
  public function move(elapsed:Float) {
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
    bloodEmitter.setPosition(x + origin.x, y + origin.y);

    // Move health bar above sprite
    var barX = x + origin.x - healthBar.origin.x;
    var barY = y - healthBar.origin.y - 10;
    healthBar.setPosition(barX, barY);

    super.update(elapsed);
  }

  // Kill stuff
  public override function kill() {
    if (arm != null) {
      arm.kill();
    }
    healthBar.kill();
    bloodEmitter.kill();
  }

  // Get arrows
  public static function getArrows():FlxTypedGroup<Arrow> {
    return arrowContainer;
  }

  // Clean up arrows
  public static function cleanUpArrows() {
    arrowContainer.forEachDead(function(arrow) {
      if (arrow.exists == false) {
        arrowContainer.remove(arrow);
      }
    });
  }

  // On hit
  public function takeDamage(damage:Float, angleBetween:Float) {
    health -= damage;
    bloodEmitter.launchAngle.set(angleBetween - 25, angleBetween + 25);
    bloodEmitter.start(true, 0, 20);
    hitSound.play();
  }

  // Add arm
  public function pickupArm(arm:Arm) {
    if (this.arm != null) {
      this.arm.kill();
      FlxG.state.remove(this.arm);
    }
    this.arm = arm;
    arm.revive();
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

  public function moveLeft() {
    // Movement
    if (velocity.x > -movementSpeedMax) {
      // Less movement acceleration when jumping
      if (!jumping) {
        acceleration.x = -movementSpeedChange * (movementSpeedMax + velocity.x);
      }
      else {
        acceleration.x = -movementSpeedChange * MOVEMENT_SPEED_JUMPING_CHANGE * (movementSpeedMax + velocity.x);
      }
    }
    // Stop accelerating when we fast
    else if (velocity.x <= -movementSpeedMax) {
      acceleration.x = 0;
    }

    // Animaiton
    animation.play("walk");
    // Flip
    if (scale.x > 0) {
      scale.x *= -1;
    }
  }

  public function moveRight() {
    // Movement
    if (velocity.x < movementSpeedMax) {
      // Less movement acceleration when jumping
      if (!jumping) {
        acceleration.x = movementSpeedChange * (movementSpeedMax - velocity.x);
      }
      else {
        acceleration.x = movementSpeedChange * MOVEMENT_SPEED_JUMPING_CHANGE * (movementSpeedMax + velocity.x);
      }
    }
    // Stop accelerating when we fast
    else if (velocity.x >= movementSpeedMax) {
      acceleration.x = 0;
    }
    // Animation
    animation.play("walk");

    // Flip
    if (scale.x < 0) {
      scale.x *= -1;
    }
  }
}
