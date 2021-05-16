package;

// Imports
import allanly.Arrow;
import allanly.ArrowUi;
import allanly.Background;
import allanly.BowBasic;
import allanly.Campfire;
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
import allanly.Team;
import allanly.Throne;
import allanly.Tirefire;
import allanly.Tools;
import allanly.Torch;
import allanly.Tree;
import allanly.WinPointer;
import flixel.FlxG;
import flixel.FlxSprite;
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

  // Level
  private var levelFront:FlxTilemap;
  private var levelMid:FlxTilemap;
  private var levelBack:FlxTilemap;
  private var levelCollide:FlxTilemap;
  private var arrowUi:ArrowUi;

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

    // Create location for pointer so no crashing
    gameCrank = new Crank(-100, -100);
    gameCrown = new Crown(-100, -100);
    gameDrawbridge = new Drawbridge(-100, -100, 0, 0);
    gameSpawn = new Spawn(-100, -100, 0, 0);

    loadMap(levelOn);

    // Arrows
    Character.arrowContainer = new FlxTypedGroup<Arrow>();
    FlxG.state.add(Character.arrowContainer);

    // Zoom and follow
    FlxG.camera.follow(jim, PLATFORMER, 1);
    FlxG.camera.zoom = 1;

    if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
      FlxG.sound.playMusic(AssetPaths.menu__mp3, 0.6, true);
    }

    arrowUi = new ArrowUi(jim);
    add(arrowUi);
  }

  // HINT: THIS UPDATES
  // THANKS TIPS
  override public function update(elapsed:Float) {
    enemies.forEachDead(function(enemy) {
      if (enemy.exists == false) {
        enemies.remove(enemy);
      }
    });

    // Remove non existant arrows
    Character.cleanUpArrows();

    // Collide everybuddy
    FlxG.collide(enemies, levelCollide);
    FlxG.collide(jim, levelCollide);
    if (jim.getDrone() != null) {
      FlxG.collide(jim.getDrone(), levelCollide);
    }

    // Arrow vs door
    FlxG.overlap(Character.getArrows(), doors, function hitDoorArrow(arrow:Arrow, door:Door) {
      // Door is closed
      if (arrow.alive && (door.scale.x <= 0.2 || door.scale.x >= -0.2)) {
        arrow.velocity.x /= 1.2;
        arrow.velocity.y /= 1.2;
        door.hitDoor(arrow.velocity.x);
      }
    });

    // Arrow vs world
    FlxG.collide(Character.getArrows(), levelCollide, function arrowCollideWorld(arrow:Arrow, world:FlxSprite) {
      if (arrow.alive) {
        arrow.kill();
      }
    });

    // kill "friends"
    FlxG.overlap(Character.getArrows(), enemies, function hitEnemy(arrow:Arrow, enemy:Enemy) {
      if (arrow.getTeam() == Team.PLAYER && arrow.velocity.x != 0 && arrow.velocity.y != 0 && arrow.alive && enemy.alive) {
        var angleBetween = FlxAngle.angleBetween(arrow, enemy, true);
        var totalVelocity = VelocityHelpers.getTotalVelocity(arrow.velocity);
        enemy.takeDamage(Math.abs(totalVelocity), angleBetween);

        // Spawn stuck arrow
        var stuckArrow = new StuckArrow(enemy, arrow.x, arrow.y, arrow.angle);
        add(stuckArrow);
        arrow.finishKill();
      }
    });

    // Arrow vs jim
    FlxG.overlap(Character.getArrows(), jim, function(arrow:Arrow, player:Player) {
      if (arrow.getTeam() == Team.ENEMY && arrow.velocity.x != 0 && arrow.velocity.y != 0 && arrow.alive) {
        var angleBetween = FlxAngle.angleBetween(arrow, player, true);
        var totalVelocity = VelocityHelpers.getTotalVelocity(arrow.velocity);
        player.takeDamage(Math.abs(totalVelocity), angleBetween);

        // Spawn stuck arrow
        var stuckArrow = new StuckArrow(player, arrow.x, arrow.y, arrow.angle);
        add(stuckArrow);
        arrow.finishKill();
      }
    });

    // Ladders
    jim.onLadder(FlxG.overlap(jim, ladders, jim.ladderPosition));

    // Door action
    if (jim.getDrone() != null)
      FlxG.overlap(jim.getDrone(), doors, function collideDoor(player:Character, door:Door) {
        door.hitDoor(player.velocity.x);
      });

    // Run into draw bridge
    FlxG.collide(jim, gameDrawbridge);
    if (jim.getDrone() != null)
      FlxG.collide(jim.getDrone(), gameDrawbridge);

    FlxG.overlap(jim, doors, function collideDoor(player:Character, door:Door) {
      door.hitDoor(player.velocity.x);
    });

    FlxG.overlap(enemies, doors, function collideDoor(player:Character, door:Door) {
      door.hitDoor(player.velocity.x);
    });

    // Run into draw bridge
    FlxG.collide(jim, gameDrawbridge);
    FlxG.collide(enemies, gameDrawbridge);
    FlxG.collide(Character.getArrows(), gameDrawbridge);

    // Win!
    if (FlxG.overlap(jim, gameSpawn) && gameCrown.isTaken()) {
      jim.win();
    }

    // The drawbridge + crank
    if (FlxG.overlap(gameCrank, Character.getArrows()) && !gameCrank.getActivated()) {
      gameDrawbridge.fall();
      gameCrank.spin();
    }

    // Crown
    if (FlxG.overlap(gameCrown, jim)) {
      gameCrown.takeCrown();
      winPointer.enable();
    }

    // Die
    FlxG.overlap(jim, enemies, function(jim:Player, enemy:Enemy) {
      if (enemy.alive) {
        jim.takeDamage(100, 0);
        FlxG.sound.music.stop();
      }
    });

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

  // Load each layer
  private function loadMap(levelOn:Int) {
    // trace("Loading Map!");

    // Tiles for level
    var spritesheet:String = AssetPaths.level1_tiles__png;
    var tmx:TiledMap;

    if (levelOn == 1) {
      tmx = new TiledMap(AssetPaths.level1_map__tmx);
    }
    else if (levelOn == 2) {
      tmx = new TiledMap(AssetPaths.level2_map__tmx);
    }
    else if (levelOn == 3) {
      tmx = new TiledMap(AssetPaths.level3_map__tmx);
    }
    else {
      return;
    }

    // Set background color
    bgColor = tmx.backgroundColor;

    // Background
    var background = tmx.properties.get("background");
    var offset = Std.parseInt(tmx.properties.get("offset"));
    var baseOffset = Std.parseInt(tmx.properties.get("base_offset"));
    var gradient1 = tmx.properties.get("gradient_1");
    var gradient2 = tmx.properties.get("gradient_2");

    if (background.length > 0 && offset != null && baseOffset != null && gradient1 != null && gradient2 != null) {
      sceneBackground = new Background(background, offset, baseOffset, gradient1, gradient2);
      trace("Background loaded " + background + " offset:" + offset + " base offset:" + baseOffset);
    }
    else {
      trace("Background load failed");
    }

    levelFront = new FlxTilemap();
    levelMid = new FlxTilemap();
    levelBack = new FlxTilemap();
    levelCollide = new FlxTilemap();

    add(levelBack);
    add(levelMid);
    add(levelFront);
    add(levelCollide);

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
          }
        }

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
        add(jim);

        gameSpawn = new Spawn(obj.x, obj.y, obj.width, obj.height);
        add(gameSpawn);

        // Win pointer
        winPointer = new WinPointer(gameSpawn, jim);
        add(winPointer);

        return;
      case "enemy":
        var enemy = new EnemySword(jim, obj.name, obj.x, obj.y);
        enemies.add(enemy);
        add(enemy);
        return;
      case "enemy_bow":
        var enemy = new EnemyArcher(jim, obj.name, obj.x, obj.y);
        enemies.add(enemy);
        add(enemy);
        return;
      case "door":
        var door = new Door(obj.x, obj.y, obj.height);
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
      case "tirefire":
        add(new Tirefire(obj.x, obj.y));
        return;
      case "campfire":
        add(new Campfire(obj.x, obj.y));
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
