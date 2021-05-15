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

// Swinging enemies
class Enemy extends Character {
  // Constants
  private static inline final JUMP_VELOCITY:Float = 250.0;

  private var heySound:FlxSound;

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

  // Create enemy
  public function new(jimPointer:Character, name:String, x:Float = 0, y:Float = 0) {
    super(x, y - 40);

    // Set id
    this.name = name;

    // Init vars
    detected = false;
    patrolling = false;
    patrolPointIndex = 0;

    // Player
    this.jimPointer = jimPointer;

    // Init health
    health = 100;

    // Load sounds
    heySound = new FlxSound();
    heySound.loadEmbedded(AssetPaths.enemy_hey__mp3);

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
  }

  public function detectPlayer() {
    detected = true;
    patrolling = false;

    // Hey! sound
    heySound.proximity(x, y, jimPointer, 800, true);
    heySound.play();
  }

  // Move around
  override public function move(elapsed:Float) {
    // Detection
    var distance = Tools.getDistance(new FlxPoint(x, y), new FlxPoint(jimPointer.x, jimPointer.y));
    if (!detected && distance < 50 && health > 0) {
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
  public function getHit(velocity:Float, angleBetween:Float) {
    takeDamage(Math.abs(velocity / 10.0), angleBetween);
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
