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
import flixel.text.FlxBitmapText;
import ui.PixelText;

class ArrowUi extends FlxSprite {
  // Variables
  private static var currentBow:Int = 0;

  private var bowTiles:Array<FlxSprite>;

  // Ammo and bow name text
  private var ammoText:FlxBitmapText;
  private var bowText:FlxBitmapText;

  // Shows the aim point when aiming with a gamepad, as there is no mouse cursor
  private var crosshair:FlxSprite;
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

    bowText = PixelText.create("", 10, 10, 2);
    FlxG.state.add(bowText);

    ammoText = PixelText.create("", 10, 10, 2);
    FlxG.state.add(ammoText);

    crosshair = new FlxSprite(0, 0, AssetPaths.cursor__png);
    crosshair.visible = false;
    FlxG.state.add(crosshair);

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

    bowText.x = FlxG.camera.scroll.x + 10;
    bowText.y = FlxG.camera.scroll.y + 62;
    bowText.text = jimPointer.getArm().getName();

    ammoText.x = FlxG.camera.scroll.x + 10;
    ammoText.y = FlxG.camera.scroll.y + 80;
    ammoText.text = "Arrows: " + jimPointer.getAmmo();

    // Runs after the player has updated this frame's aim
    crosshair.visible = Controls.gamepadAim;
    crosshair.setPosition(Controls.aim.x - crosshair.width / 2, Controls.aim.y - crosshair.height / 2);
  }

  public static function setBow(bow:Int) {
    currentBow = bow;
  }
}
