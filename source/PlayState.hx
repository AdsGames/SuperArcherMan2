package;

// Imports
import allanly.Arrow;
import allanly.Background;
import allanly.Bow;
import allanly.Character;
import allanly.Cloud;
import allanly.Crank;
import allanly.Crown;
import allanly.Door;
import allanly.Drawbridge;
import allanly.Enemy;
import allanly.EnemyArcher;
import allanly.EnemySword;
import allanly.Ladder;
import allanly.Painting;
import allanly.Player;
import allanly.Spawn;
import allanly.StuckArrow;
import allanly.Sword;
import allanly.Throne;
import allanly.Tools;
import allanly.Torch;
import allanly.Tree;
import allanly.WinPointer;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import helpers.VelocityHelpers;

// THE GAME!
class PlayState extends FlxState {
  // Level Number
  public static var levelOn:Int;

  // Background
  private var sceneBackground:Background;

  // Group to hold all the guys
  private var enemies:FlxTypedGroup<Enemy>;

  // Hold ladders
  private var ladders:FlxTypedGroup<Ladder>;

  // Hold doors
  private var doors:FlxTypedGroup<Door>;

  // Cranks/drawbridges
  private var gameCrank:Crank;
  private var gameDrawbridge:Drawbridge;

  // Crown
  private var gameCrown:Crown;

  // Spawn point
  private var gameSpawn:Spawn;

  // I have no idea how to use flixel
  // Win pointer
  private var winPointer:WinPointer;

  // Player
  private var jim:Player;

  // Power text
  private var powerText:FlxText;

  // Level
  private var levelFront:FlxTilemap;
  private var levelMid:FlxTilemap;
  private var levelBack:FlxTilemap;
  private var levelCollide:FlxTilemap;

  // Our class constructor
  public function new(levelOn:Int) {
    super();

    PlayState.levelOn = levelOn;
  }

  // Creates some stuff
  override public function create() {
    // Mouse
    FlxG.mouse.visible = true;

    // Group to store players
    enemies = new FlxTypedGroup<Enemy>();

    // Ladders
    ladders = new FlxTypedGroup<Ladder>();

    // Doors
    doors = new FlxTypedGroup<Door>();

    // Background
    sceneBackground = new Background(5000);

    // Create location for pointer so no crashing
    gameCrank = new Crank(-100, -100);
    gameCrown = new Crown(-100, -100);
    gameDrawbridge = new Drawbridge(-100, -100, 0, 0);
    gameSpawn = new Spawn(-100, -100, 0, 0);

    loadMap(levelOn);

    // Power text
    powerText = new FlxText(0, 0, 0, "");
    add(powerText);

    // Zoom and follow
    FlxG.camera.follow(jim, PLATFORMER, 1);

    if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
      FlxG.sound.playMusic(AssetPaths.music__mp3, 0.1, true);
    }
  }

  // HINT: THIS UPDATES
  // THANKS TIPS
  override public function update(elapsed:Float) {
    // trace("kill me right now"); // Move power text to mouse
    powerText.x = FlxG.mouse.x + 15;
    powerText.y = FlxG.mouse.y;

    var bow = Std.downcast(jim.getArm(), Bow);
    if (jim.getDrone() != null)
      bow = jim.getDrone().getBow();
    if (bow != null) {
      powerText.text = "" + bow.getPower() + "%";
    }

    // Collide everybuddy
    FlxG.collide(enemies, levelCollide);
    FlxG.collide(jim, levelCollide);
    FlxG.collide(jim.getArrows(), levelCollide);
    if (jim.getDrone() != null)
      FlxG.collide(jim.getDrone(), levelCollide);

    FlxG.overlap(jim.getArrows(), doors, hitDoorArrow);

    // kill "friends"
    FlxG.overlap(jim.getArrows(), enemies, hitEnemy);

    // Ladders
    jim.onLadder(FlxG.overlap(jim, ladders, jim.ladderPosition));

    // Door action
    FlxG.overlap(jim, doors, collideDoor);
    if (jim.getDrone() != null)
      FlxG.overlap(jim.getDrone(), doors, collideDoor);

    // Run into draw bridge
    FlxG.collide(jim, gameDrawbridge);
    if (jim.getDrone() != null)
      FlxG.collide(jim.getDrone(), gameDrawbridge);

    FlxG.overlap(enemies, doors, collideDoor);

    // Run into draw bridge
    FlxG.collide(jim, gameDrawbridge);
    FlxG.collide(enemies, gameDrawbridge);
    FlxG.collide(jim.getArrows(), gameDrawbridge);

    // Win!
    if (FlxG.overlap(jim, gameSpawn) && gameCrown.isTaken()) {
      jim.win();
    }

    // The drawbridge + crank
    if (FlxG.overlap(gameCrank, jim.getArrows()) && !gameCrank.getActivated()) {
      gameDrawbridge.fall();
      gameCrank.spin();
    }

    // Crown
    if (FlxG.overlap(gameCrown, jim)) {
      gameCrown.takeCrown();
      winPointer.enable();
    }

    // Die
    if (FlxG.overlap(jim, enemies)) {
      jim.die();
      FlxG.sound.music.stop();
    }

    // Make some clouds
    if (Tools.myRandom(0, 1000) == 1) {
      add(new Cloud(-100, Tools.myRandom(0, 200)));
    }

    // Menu
    if (FlxG.keys.pressed.ESCAPE) {
      FlxG.switchState(new MenuState());
      FlxG.sound.music.stop();
    }

    super.update(elapsed);
  }

  // Door actions
  private function collideDoor(player:Character, door:Door) {
    door.hitDoor(player.velocity.x);
  }

  // Arrows through door
  private function hitDoorArrow(arrow:Arrow, door:Door) {
    // Door is closed
    if (!arrow.dead && (door.scale.x <= 0.2 || door.scale.x >= -0.2)) {
      arrow.velocity.x /= 1.2;
      arrow.velocity.y /= 1.2;
      door.hitDoor(arrow.velocity.x);
    }
  }

  // Enemy actions
  private function hitEnemy(arrow:Arrow, enemy:Enemy) {
    if (arrow.velocity.x != 0 && arrow.velocity.y != 0 && !arrow.dead) {
      var angleBetween = FlxAngle.angleBetween(arrow, enemy, true);
      var totalVelocity = VelocityHelpers.getTotalVelocity(arrow.velocity);
      enemy.getHit(totalVelocity, angleBetween);

      // Spawn stuck arrow
      var stuckArrow = new StuckArrow(enemy, arrow.x, arrow.y, arrow.angle);
      add(stuckArrow);
      arrow.kill();

      if (enemy.health <= 0) {
        enemies.remove(enemy);
      }
    }
  }

  // Load each layer
  private function loadMap(levelOn:Int) {
    // trace("Loading Map!");

    levelFront = new FlxTilemap();
    levelMid = new FlxTilemap();
    levelBack = new FlxTilemap();
    levelCollide = new FlxTilemap();

    add(levelBack);
    add(levelMid);
    add(levelFront);
    add(levelCollide);

    // Tiles for level
    var spritesheet:String = "";
    var tmx:TiledMap;

    if (levelOn == 1) {
      spritesheet = AssetPaths.level1_tiles__png;
      tmx = new TiledMap(AssetPaths.level1_map__tmx);
    }
    else if (levelOn == 2) {
      spritesheet = AssetPaths.level2_tiles__png;
      tmx = new TiledMap(AssetPaths.level2_map__tmx);
    }
    else if (levelOn == 3) {
      spritesheet = AssetPaths.level3_tiles__png;
      tmx = new TiledMap(AssetPaths.level3_map__tmx);
    }
    else {
      return;
    }

    // Set background color
    bgColor = tmx.backgroundColor;

    // Parse layers
    for (layer in tmx.layers) {
      if (layer.type == TILE) {
        var tileLayer:TiledTileLayer = cast(layer, TiledTileLayer);
        if (layer.name == "collide") {
          levelCollide.loadMapFromArray(tileLayer.tileArray, tileLayer.width, tileLayer.height, spritesheet, 16, 16, OFF, 1);
          levelCollide.follow();
        }
        else if (layer.name == "front") {
          levelFront.loadMapFromArray(tileLayer.tileArray, tileLayer.width, tileLayer.height, spritesheet, 16, 16, OFF, 1);
          levelFront.follow();
        }
        else if (layer.name == "back") {
          levelBack.loadMapFromArray(tileLayer.tileArray, tileLayer.width, tileLayer.height, spritesheet, 16, 16, OFF, 1);
          levelBack.follow();
        }
        else if (layer.name == "mid") {
          levelMid.loadMapFromArray(tileLayer.tileArray, tileLayer.width, tileLayer.height, spritesheet, 16, 16, OFF, 1);
          levelMid.follow();
        }
      }
      else if (layer.type == OBJECT) {
        if (layer.name == "objects") {
          var objLayer:TiledObjectLayer = cast(layer, TiledObjectLayer);
          spawnObjects(objLayer);
        }
        else if (layer.name == "nodes") {
          var objLayer:TiledObjectLayer = cast(layer, TiledObjectLayer);
          loadNodes(objLayer);
        }
      }
    }
  }

  // Load nodes from tiled obj layer
  private function loadNodes(group:TiledObjectLayer) {
    for (obj in group.objects) {
      loadNode(obj);
    }
  }

  // Single node load
  private function loadNode(obj:TiledObject) {
    // No type, we use name
    switch (obj.name) {
      case "patrol":
        var enemyName = obj.properties.get("enemy_name");
        if (enemyName.length == 0) {
          trace("Patrol point " + obj.gid + " has no enemy_name");
          return;
        }

        // Find paired enemy
        for (enemy in enemies) {
          if (enemy.getName() == enemyName) {
            enemy.addPatrolPoint(new FlxPoint(obj.x, obj.y));
            return;
          }
        }

        // Not found
        trace("Could not find enemy " + enemyName + " for patrol route");

      default:
        trace("Could not load node " + obj.gid);
        return;
    }
  }

  // Spawn objects using tiled object layer
  private function spawnObjects(group:TiledObjectLayer) {
    // Spawn stuff
    for (obj in group.objects) {
      spawnObject(obj);
    }
  }

  private function spawnObject(obj:TiledObject) {
    // Add game objects based on the 'type' property
    switch (obj.type) {
      case "player":
        // Add player
        jim = new Player(0, 0);
        jim.setPosition(obj.x, obj.y);
        jim.pickupArm(new Bow(600.0, 1.0, 100.0));
        add(jim);

        // drone = new Drone(jim); // Load map :D
        //                                   ^ turn that frown upside down

        // add(drone); // Add ur bum

        gameSpawn = new Spawn(obj.x, obj.y, obj.width, obj.height);
        add(gameSpawn);

        // Win pointer
        winPointer = new WinPointer(gameSpawn, jim);
        add(winPointer);

        return;
      case "enemy":
        var enemy = new EnemySword(jim, obj.name, obj.x, obj.y);
        enemy.pickupArm(new Sword());
        enemies.add(enemy);
        add(enemy);
        return;
      case "enemy_bow":
        var enemy = new EnemyArcher(jim, obj.name, obj.x, obj.y);
        enemy.pickupArm(new Bow(1000.0, 1.0, 100.0));
        enemies.add(enemy);
        add(enemy);
        return;
      case "door":
        var door = new Door(obj.x, obj.y);
        add(door);
        doors.add(door);
        return;
      case "torch":
        add(new Torch(obj.x, obj.y));
        return;
      case "tree":
        add(new Tree(obj.x, obj.y));
        return;
      case "ladder":
        ladders.add(new Ladder(obj.x, obj.y, obj.width, obj.height));
        return;
      case "crown":
        gameCrown.setPosition(obj.x, obj.y);
        add(gameCrown);
        return;
      case "painting":
        add(new Painting(obj.x, obj.y));
        return;
      case "throne":
        add(new Throne(obj.x, obj.y));
        return;
      case "drawBridge":
        gameDrawbridge = new Drawbridge(obj.x, obj.y, obj.width, obj.height);
        add(gameDrawbridge);
        return;
      case "crank":
        gameCrank.setPosition(obj.x, obj.y);
        add(gameCrank);
        return;
      case "water":
        // var water = new Water(obj.x, obj.y, obj.width, obj.height);
        return;
      default:
        trace("Unknown map object type: " + obj.type + " id:" + obj.gid);
        return;
    }
  }
}
// I literally want to die
