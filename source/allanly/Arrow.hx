package allanly;

/**
 * Arrow
 * ALLAN AND SULLY!
 * Arrows and nice stuff!
 * 31/5/2015
 */
// Imports
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;

// Realistic arrows
class Arrow extends FlxSprite {
  private var parent:FlxObject;

  // Sounds
  private var arrowHitSound:FlxSound;
  private var bowReleaseSound:FlxSound;

  // Dead arrow
  public var dead:Bool;

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

  // Update arrow
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Update sounds
    arrowHitSound.update(elapsed);

    // Update unless dead
    if (!dead) {
      // Fall a bit
      if (velocity.y == 0 || velocity.x == 0) {
        velocity.y = 0;
        velocity.x = 0;
        dead = true;
        arrowHitSound.proximity(x, y, parent, 800, true);
        arrowHitSound.play();
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
