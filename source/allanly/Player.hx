package allanly;

/**
 * Player class
 * ALLAN AND SULLY!
 * Our main character, jim
 * 29/5/2015
 */
// Imports
import flixel.FlxG;
import flixel.util.FlxTimer;

class Player extends Character {
  // Timers
  private var counter:Int;

  // Active drone (null when not deployed)
  private var drone:Drone;

  // Drone instance, reused between deployments
  private var dronePool:Drone;

  // Variables
  private var isOnLadder:Bool;
  private var ladderX:Float;
  private var dead:Bool;
  private var hasWon:Bool;
  private var bows:Array<Bow>;
  private var currentBow:Int;
  private var droneFollower:Follower;

  // Constants
  private static inline final JUMP_VELOCITY:Float = 250.0;
  private static inline final DEATH_TIMER:Float = 3;
  private static inline final DRONE_AMMO:Int = 1;

  // Make character
  public function new(x:Float = 0, y:Float = 0) {
    // Create jim
    super(x, y);

    // Default values
    counter = 0;
    currentBow = 0;
    movementSpeedMax = 200;

    // Variables
    isOnLadder = false;
    ladderX = 0;
    dead = false;
    hasWon = false;

    // Follower
    droneFollower = new Follower(x, y, this);
    FlxG.state.add(droneFollower);

    // Init health
    health = 10000;
    healthBar.setRange(0, health);

    // Images and animations
    loadGraphic(AssetPaths.player__png, true, 23, 30);
    animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
    animation.add("idle", [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31], 5, true);
    animation.add("climb", [64, 65, 66, 67], 5, true);
    animation.add("die", [
      32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62
    ], 15, false);
    animation.play("idle");

    // BB Offset
    width = 16;
    offset.set(3, 0);

    // Say a little something on creation
    var randomSaying:Int = Tools.myRandom(0, 4);
    if (randomSaying == 1) {
      FlxG.sound.play(AssetPaths.jim_saying1__mp3);
    }
    else if (randomSaying == 2) {
      FlxG.sound.play(AssetPaths.jim_saying2__mp3);
    }
    else if (randomSaying == 3) {
      FlxG.sound.play(AssetPaths.jim_saying3__mp3);
    }
    else if (randomSaying == 4) {
      FlxG.sound.play(AssetPaths.jim_saying4__mp3);
    }

    bows = [
      new BowBasic(600.0, 3.0, 100.0, Team.PLAYER, 1000),
      new BowTriple(600, 5, 100, Team.PLAYER, 20),
      new BowAutomatic(400, 0.2, 100, Team.PLAYER, 50),
      new BowShotgun(400, 9, 20, Team.PLAYER, 10)
    ];

    pickupArm(bows[0]);
  }

  // Update
  override public function update(elapsed:Float) {
    // Update parent
    super.update(elapsed);
    droneFollower.setVisible(drone == null);
    // Kill urself
    // Don't threaten me with a good time
    if (Controls.suicide()) {
      health = 0;
    }

    // Update bow target
    if (!dead) {
      // Pickup drone
      if (Controls.toggleDrone()) {
        if (drone != null) {
          FlxG.overlap(this, drone, function collideDrone(_, _drone:Drone) {
            _drone.kill();
            drone = null;
            FlxG.camera.follow(this, PLATFORMER, 1);
            FlxG.camera.zoom = 1;
          });
        }
        else {
          if (dronePool == null) {
            dronePool = new Drone(x, y, this);
            dronePool.pickupArm(new BowBasic(1000, 2.5, 100, Team.PLAYER, DRONE_AMMO));
            FlxG.state.add(dronePool);
          }
          else {
            dronePool.deploy(x, y);
            dronePool.getBow().setAmmo(DRONE_AMMO);
          }
          drone = dronePool;
          FlxG.camera.follow(drone, LOCKON, 1.3);
          FlxG.camera.zoom = 1.8;
        }
      }

      // Move around (before aiming, so the bow is at this frame's position)
      move(elapsed);

      var bow = Std.downcast(arm, Bow);
      if (drone != null) {
        bow = drone.getBow();
      }
      var aim = Controls.updateAim(bow.x + bow.width / 2, bow.y + bow.height / 2);
      bow.setTarget(aim.x, aim.y);

      // Make arrows
      if (Controls.fireJustPressed()) {
        bow.pullBack();
      }
      else if (Controls.fireJustReleased()) {
        bow.release();
      }

      if (health <= 0) {
        die();
      }
    }

    // Win
    // no
    if (hasWon && counter >= DEATH_TIMER) {
      FlxG.sound.music.stop();
      counter = 0;
      FlxG.switchState(() -> new MenuState());
    }

    if (dead && counter >= DEATH_TIMER) {
      FlxG.sound.music.stop();
      FlxG.switchState(() -> new PlayState(PlayState.levelOn));
    }
  }

  // Move character (keep out danny)
  // more like keep this rope off my neck
  override public function move(elapsed:Float) {
    ignoreGravity = isOnLadder;

    // Switch bow
    if (FlxG.keys.justPressed.ONE) {
      selectBow(0);
    }
    else if (FlxG.keys.justPressed.TWO) {
      selectBow(1);
    }
    else if (FlxG.keys.justPressed.THREE) {
      selectBow(2);
    }
    else if (FlxG.keys.justPressed.FOUR) {
      selectBow(3);
    }
    else if (Controls.nextBow()) {
      selectBow((currentBow + 1) % bows.length);
    }
    else if (Controls.previousBow()) {
      selectBow((currentBow + bows.length - 1) % bows.length);
    }

    // Right
    if (Controls.right(D)) {
      moveRight();
    }

    // Left
    if (Controls.left(A)) {
      moveLeft();
    }

    // Ladder
    if (isOnLadder) {
      if (Controls.up(W)) {
        animation.play("climb");
        y -= 1;
      }
      else if (Controls.down(S)) {
        animation.play("climb");
        y += 1;
      }
    }
    // Jump Jump!
    // me on the edge of the building
    if (Controls.jump()) {
      jump(JUMP_VELOCITY);
    }
    // Idleing
    if (!Controls.left(A) && !Controls.right(D)) {
      // Stopped
      if (velocity.x < 5 && velocity.x > -5) {
        acceleration.x = 0;
        velocity.x = 0;

        // Resolve animation if we're on a ladder
        if (!isOnLadder) {
          animation.play("idle");
        }
        else {
          animation.play("climb");
        }
      }
      // Decelerating
      else if (velocity.x > 0) {
        acceleration.x = -movementSpeedChange * MOVEMENT_SPEED_DECELERATION_CHANGE * (movementSpeedMax + velocity.x);

        // Resolve animation if we're on a ladder
        if (!isOnLadder) {
          animation.play("walk");
        }
        else {
          animation.play("climb");
        }
      }
      else if (velocity.x < 0) {
        acceleration.x = movementSpeedChange * MOVEMENT_SPEED_DECELERATION_CHANGE * (movementSpeedMax - velocity.x);

        // Resolve animation if we're on a ladder
        // ur butt is on a ladder
        if (!isOnLadder) {
          animation.play("walk");
        }
        else {
          animation.play("climb");
        }
      }
    }

    super.move(elapsed);
  }

  // Equip bow by index, ignore if already held
  private function selectBow(index:Int) {
    if (arm == bows[index]) {
      return;
    }
    currentBow = index;
    pickupArm(bows[currentBow]);
    ArrowUi.setBow(currentBow);
  }

  // ur butt
  public function getDrone():Drone {
    return drone;
  }

  // Die
  public function die() {
    if (!dead) {
      animation.play("die");
      arm.visible = false;
      dead = true;
      FlxG.sound.music.stop();
      FlxG.sound.play(AssetPaths.bell__mp3);
      startTimer();
      velocity.x = 0;
      acceleration.x = 0;
    }
  }

  public function getAmmo() {
    if (drone != null) {
      return drone.getBow().getAmmo();
    }
    return Std.downcast(arm, Bow).getAmmo();
  }

  // Win
  // kys
  public function win() {
    if (!hasWon) {
      hasWon = true;
      FlxG.sound.play(AssetPaths.win__wav);
      startTimer();
    }
  }

  // Ready to climb
  public function onLadder(isOnLadder:Bool) {
    this.isOnLadder = isOnLadder;

    if (isOnLadder) {
      if (Controls.up(W) || Controls.down(S)) {
        x = ladderX;
      }
    }
  }

  // Ready to climb
  public function ladderPosition(player:Player, ladder:Ladder) {
    ladderX = ladder.x;
  }

  // Start power timer
  private function startTimer() {
    counter = 0;
    new FlxTimer().start(1, incrementTimer, 0);
  }

  // Death timer
  private function incrementTimer(timer:FlxTimer) {
    counter++;
  }
}
