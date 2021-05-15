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

// Realistic arrows
class Arrow extends FlxSprite {
  private var parent:FlxObject;

  // Sounds
  private var arrowHitSound:FlxSound;
  private var bowReleaseSound:FlxSound;

  // Dead arrow
  public var dead:Bool;

  // The emitter
  public var trailEmitter:FlxEmitter;

  // Create arrow
  public function new(parent:FlxObject, x:Float = 0, y:Float = 0, angle:Float = 0, velocity:Float = 2, mass:Float = 1) {
    super(x, y, AssetPaths.arrow__png);
    this.angle = angle;
    this.mass = mass;
    this.velocity.x = -Math.cos((angle + 90) * (Math.PI / 180)) * velocity;
    this.velocity.y = -Math.sin((angle + 90) * (Math.PI / 180)) * velocity;

    this.parent = parent;
    dead = false;

    // Shrink box
    offset.y = 1;
    height -= 2;
    offset.x = 7;
    width -= 13;

    // Make sure x/y velocity is never 0 to help below scripts
    if (this.velocity.x == 0) {
      this.velocity.x = 0.01;
    }
    if (this.velocity.y == 0) {
      this.velocity.y = 0.01;
    }

    // Create emitter
    trailEmitter = new FlxEmitter(5, 5, 100);
    trailEmitter.loadParticles(AssetPaths.particle_star__png, 100);
    trailEmitter.scale.set(0.6, 0.6, 0.6, 0.6, 0, 0, 0, 0);
    trailEmitter.launchMode = FlxEmitterMode.CIRCLE;
    trailEmitter.speed.set(0.01, 0);
    trailEmitter.lifespan.set(0.6);
    trailEmitter.start(false, 0.05, 0);
    FlxG.state.add(trailEmitter);

    // Load sounds
    arrowHitSound = new FlxSound();
    arrowHitSound.loadEmbedded(AssetPaths.arrow_hit__mp3);

    bowReleaseSound = new FlxSound();
    bowReleaseSound.loadEmbedded(AssetPaths.bow_release__mp3);

    // Init sound
    bowReleaseSound.proximity(x, y, parent, 400, true);
    bowReleaseSound.play();

    solid = true;
  }

  // Kill
  override public function kill() {
    alive = false;
    exists = false;
    trailEmitter.emitting = false;
  }

  // Update arrow
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Update sounds
    arrowHitSound.update(elapsed);

    // Move particle emitter to obj
    trailEmitter.setPosition(this.x, this.y);

    // Update unless dead
    if (!dead) {
      // Fall a bit
      if (velocity.y == 0 || velocity.x == 0) {
        velocity.y = 0;
        velocity.x = 0;
        dead = true;
        arrowHitSound.proximity(x, y, parent, 800, true);
        arrowHitSound.play();
        trailEmitter.emitting = false;
      }
      else {
        // Fall down
        velocity.y += mass;

        // Point in proper direction
        angle = Math.atan2(velocity.y, velocity.x) * 180 / Math.PI;
      }
    }
  }
}
