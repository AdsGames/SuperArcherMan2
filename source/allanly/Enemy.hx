package allanly;

/**
 * Enemy
 * ALLAN AND SULLY!
 * This is the enemy, the archnemeis of our hero JIM!
 * 1/6/2015
 */
// Libraries
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

// Swinging enemies
class Enemy extends Character {
  // Constants
  private static inline final JUMP_VELOCITY:Float = 250.0;

  private var hitSoundRand:Int;

  private var heySound:FlxSound;
  private var hitSound1:FlxSound;
  private var hitSound2:FlxSound;
  private var hitSound3:FlxSound;

  // Variables
  private var detected:Bool;

  // Pointer to jim
  private var jimPointer:Character;

  // Global identifier from tiled
  private var name:String;

  // Patrol points
  private var patrolPoints:Array<FlxPoint>;

  // Patrol point index
  private var patrolPointIndex:Int;

  // Is patrolling
  private var patrolling:Bool;

  // Detection distance
  private var detectDistance:Int;

  // Create enemy
  public function new(jimPointer:Character, name:String, x:Float = 0, y:Float = 0) {
    super(x, y - 40);

    // Set id
    this.name = name;

    // Init vars
    detected = false;
    detectDistance = 70;
    patrolling = false;
    patrolPointIndex = 0;

    // Player
    this.jimPointer = jimPointer;

    // Init health
    health = 100;

    // Load sounds
    heySound = new FlxSound();
    heySound.loadEmbedded(AssetPaths.enemy_hey__mp3);
    hitSound1 = new FlxSound();
    hitSound1.loadEmbedded(AssetPaths.enemy_ugh__wav);
    hitSound2 = new FlxSound();
    hitSound2.loadEmbedded(AssetPaths.enemy_hu__wav);
    hitSound3 = new FlxSound();
    hitSound3.loadEmbedded(AssetPaths.enemy_oof__wav);

    // Patrol array
    patrolPoints = new Array<FlxPoint>();
  }

  // Update
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Update sound
    heySound.update(elapsed);

    // Move enemy
    move(elapsed);

    // Die
    if (health <= 0) {
      kill();
    }
  }

  public function detectPlayer() {
    // Hey! sound
    if (!detected) {
      heySound.play();
    }

    detected = true;
    patrolling = false;
  }

  // Kill
  override function kill() {
    alive = false;
    velocity.y = 0;
    velocity.x = 0;
    acceleration.y = 0;
    FlxTween.tween(this, {alpha: 0}, 2, {ease: FlxEase.circOut, onComplete: finishKill});
    super.kill();
  }

  function finishKill(_) {
    exists = false;
  }

  // Move around
  override public function move(elapsed:Float) {
    // Detection
    var distance = Tools.getDistance(new FlxPoint(x, y), new FlxPoint(jimPointer.x, jimPointer.y));
    if (!detected && distance < detectDistance && health > 0) {
      detectPlayer();
    }

    // Change patrol point
    if (patrolling && Math.abs(x - patrolPoints[patrolPointIndex].x) < 4) {
      patrolPointIndex = (patrolPointIndex + 1) % patrolPoints.length;
    }

    // Parent move
    super.move(elapsed);
  }

  // Get hit
  public override function takeDamage(damage:Float, angleBetween:Float) {
    super.takeDamage(damage, angleBetween);

    // Play hit sound if we're not playing the hey sound
    if (detected) {
      hitSoundRand = Tools.myRandom(0, 2);
      if (hitSoundRand == 0) {
        hitSound1.play();
      }
      else if (hitSoundRand == 1) {
        hitSound2.play();
      }
      else if (hitSoundRand == 2) {
        hitSound3.play();
      }
    }

    // Detect player for hitting us
    detectPlayer();
  }

  public function getName() {
    return name;
  }

  public function addPatrolPoint(point:FlxPoint) {
    patrolPoints.push(point);
    patrolling = true;
  }
}
