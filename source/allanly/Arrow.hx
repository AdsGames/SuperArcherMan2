package allanly;

/**
 * Arrow
 * ALLAN AND SULLY!
 * Arrows and nice stuff!
 * 31/5/2015
 */
// Imports
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

// Realistic arrows
class Arrow extends FlxSprite {
  private var parent:FlxObject;

  // Sounds
  private var arrowHitSound:FlxSound;
  private var arrowFlySound:FlxSound;

  private var startPos:FlxObject;

  private var yAccelertion:Int;
  private var team:Team;
  private var timeDead:Float;

  private static inline final ARROW_SPEED_MULTIPLIER:Float = 1.5;
  private static inline final ARROW_LIFESPAN:Float = 4000.0;
  private static final ANGLE_MULTIPLIER = 180 / Math.PI;

  // The emitter
  public var trailEmitter:FlxEmitter;

  // Create arrow
  public function new(parent:FlxObject, x:Float, y:Float, angle:Float, velocity:Float, team:Team) {
    super(x, y, AssetPaths.arrow__png);
    this.angle = angle;
    this.velocity.x = -Math.cos((angle + 90) * (Math.PI / 180)) * velocity;
    this.velocity.y = -Math.sin((angle + 90) * (Math.PI / 180)) * velocity;
    this.acceleration.y = 300;
    this.parent = parent;
    this.team = team;

    // This is a crap solution and is probably quite expensive. Too bad!
    this.startPos = new FlxObject(x, y, 0, 0);

    // Make sure x/y velocity is never 0 to help below scripts
    if (this.velocity.x == 0) {
      this.velocity.x = 0.01;
    }
    if (this.velocity.y == 0) {
      this.velocity.y = 0.01;
    }

    // Create emitter
    trailEmitter = new FlxEmitter(5, 5, 10);
    trailEmitter.loadParticles(AssetPaths.particle_star__png, 10);
    trailEmitter.scale.set(0.6, 0.6, 0.6, 0.6, 0, 0, 0, 0);
    trailEmitter.launchMode = FlxEmitterMode.CIRCLE;
    trailEmitter.speed.set(0.01, 0);
    trailEmitter.lifespan.set(0.6);
    trailEmitter.start(false, 0.1, 0);
    FlxG.state.add(trailEmitter);

    // Load sounds
    arrowHitSound = new FlxSound();
    arrowHitSound.loadEmbedded(AssetPaths.arrow_hit__mp3);
    arrowFlySound = new FlxSound();
    arrowFlySound.loadEmbedded(AssetPaths.arrow_fly__wav);

    solid = true;
  }

  // Kill
  override function kill() {
    arrowHitSound.play();
    alive = false;
    trailEmitter.emitting = false;
    velocity.y = 0;
    velocity.x = 0;
    acceleration.y = 0;
    FlxTween.tween(this, {alpha: 0}, 5, {
      ease: FlxEase.elasticIn,
      onComplete: function(_) {
        finishKill();
      }
    });
  }

  public function finishKill() {
    exists = false;
    trailEmitter.kill();
  }

  // Update arrow
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Move particle emitter to obj
    trailEmitter.setPosition(x + origin.x, y + origin.y);

    // Update unless dead
    if (alive) {
      angle = Math.atan2(velocity.y, velocity.x) * ANGLE_MULTIPLIER;
      arrowFlySound.play();
      arrowFlySound.update(elapsed);

      // Yep, that's right. This is how we're doing this.
      arrowFlySound.proximity(x, y, startPos, 500, true);
    }
    else
      arrowFlySound.stop();
  }

  public function getTeam() {
    return team;
  }
}
