package allanly;

/*
 * Bow
 * ALLAN AND SULLY!
 * Our main character, jim's, bow
 * 29/5/2015
 */
// Imports
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

class ArrowUi extends FlxSprite {
  // Variables
  private static var currentBow:Int = 0;

  private var bowTiles:Array<FlxSprite>;

  // Power text
  private var powerText:FlxText;
  private var bowText:FlxText;
  private var jimPointer:Player;

  // Create bow
  public function new(jimPointer:Player) {
    super();

    this.jimPointer = jimPointer;

    bowTiles = new Array<FlxSprite>();
    bowTiles.push(new FlxSprite(0, 0, AssetPaths.bow_ui__png));
    bowTiles.push(new FlxSprite(0, 0, AssetPaths.bow_triple_ui__png));
    bowTiles.push(new FlxSprite(0, 0, AssetPaths.bow_automatic_ui__png));
    bowTiles.push(new FlxSprite(0, 0, AssetPaths.bow_shotgun_ui__png));

    // Power text
    powerText = new FlxText(0, 0, 0, "");
    FlxG.state.add(powerText);

    bowText = new FlxText(10, 10, 0, "");
    FlxG.state.add(bowText);

    visible = false;

    for (tile in bowTiles) {
      FlxG.state.add(tile);
    }

    setBow(0);
  }

  // Update bow
  override public function update(elapsed:Float) {
    super.update(elapsed);

    var index = 0;
    for (tile in bowTiles) {
      tile.setPosition(FlxG.camera.scroll.x + 10 + index * 50, FlxG.camera.scroll.y + 10);

      if (currentBow == index) {
        tile.alpha = 1;
      }
      else {
        tile.alpha = 0.6;
      }

      index += 1;
    }

    powerText.x = FlxG.mouse.x + 15;
    powerText.y = FlxG.mouse.y;
    powerText.text = "Arrows: " + jimPointer.getAmmo();

    bowText.x = FlxG.camera.scroll.x + 10;
    bowText.y = FlxG.camera.scroll.y + 62;
    bowText.text = jimPointer.getArm().getName();
  }

  public static function setBow(bow:Int) {
    currentBow = bow;
  }
}
