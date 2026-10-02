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
import flixel.sound.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

// Realistic arrows
class Arrow extends FlxSprite {
  private var parent:FlxObject;

  // Sounds
  private var arrowHitSound:FlxSound;
  private var arrowFlySound:FlxSound;

  private var startPos:FlxObject;

  private var team:Team;

  // Fade out tween after hitting the world
  private var fadeTween:FlxTween;

  private static inline final ARROW_SPEED_MULTIPLIER:Float = 1.5;
  private static final ANGLE_MULTIPLIER = 180 / Math.PI;

  // The emitter
  public var trailEmitter:FlxEmitter;

  // Fire an arrow, reusing a dead one from the pool when possible
  public static function fire(parent:FlxObject, x:Float, y:Float, angle:Float, velocity:Float, team:Team) {
    var arrow = Character.arrowContainer.recycle(Arrow, Arrow.new);
    arrow.launch(parent, x, y, angle, velocity, team);
  }

  // Create arrow (pooled, call launch to fire it)
  public function new() {
    super(0, 0, AssetPaths.arrow__png);

    // This is a crap solution and is probably quite expensive. Too bad!
    this.startPos = new FlxObject(0, 0, 0, 0);

    // Create emitter
    trailEmitter = new FlxEmitter(5, 5, 10);
    trailEmitter.loadParticles(AssetPaths.particle_star__png, 10);
    trailEmitter.scale.set(0.6, 0.6, 0.6, 0.6, 0, 0, 0, 0);
    trailEmitter.launchMode = FlxEmitterMode.CIRCLE;
    trailEmitter.speed.set(0.01, 0);
    trailEmitter.lifespan.set(0.6);
    FlxG.state.add(trailEmitter);

    // Load sounds
    arrowHitSound = new FlxSound();
    arrowHitSound.load(AssetPaths.arrow_hit__mp3);
    arrowFlySound = new FlxSound();
    arrowFlySound.load(AssetPaths.arrow_fly__wav);
  }

  // Reset state and launch
  public function launch(parent:FlxObject, x:Float, y:Float, angle:Float, velocity:Float, team:Team) {
    reset(x, y);
    this.angle = angle;
    this.velocity.x = -Math.cos((angle + 90) * (Math.PI / 180)) * velocity;
    this.velocity.y = -Math.sin((angle + 90) * (Math.PI / 180)) * velocity;
    this.acceleration.y = 300;
    this.parent = parent;
    this.team = team;
    alpha = 1;
    solid = true;
    startPos.setPosition(x, y);

    // Make sure x/y velocity is never 0 to help below scripts
    if (this.velocity.x == 0) {
      this.velocity.x = 0.01;
    }
    if (this.velocity.y == 0) {
      this.velocity.y = 0.01;
    }

    trailEmitter.setPosition(x + origin.x, y + origin.y);
    trailEmitter.start(false, 0.1, 0);
  }

  // Kill
  override function kill() {
    arrowHitSound.play();
    alive = false;
    solid = false;
    trailEmitter.emitting = false;
    velocity.y = 0;
    velocity.x = 0;
    acceleration.y = 0;
    fadeTween = FlxTween.tween(this, {alpha: 0}, 5, {
      ease: FlxEase.elasticIn,
      onComplete: function(_) {
        finishKill();
      }
    });
  }

  // Remove from play, frees the arrow for reuse
  public function finishKill() {
    if (fadeTween != null) {
      fadeTween.cancel();
      fadeTween = null;
    }
    alive = false;
    exists = false;
    solid = false;
    arrowFlySound.stop();
    trailEmitter.kill();
  }

  // Update arrow
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Move particle emitter to obj
    trailEmitter.setPosition(x + origin.x, y + origin.y);

    // Update unless dead
    if (alive) {
      // Fell or flew out of the world, it will never hit anything
      var bounds = FlxG.worldBounds;
      if (x < bounds.left || x > bounds.right || y > bounds.bottom) {
        finishKill();
        return;
      }

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
