package;

/**
 * ALLAN AND SULLY!
 * Creator of game state
 * 5/28/2015
 */
// Imports
import flixel.FlxG;
import flixel.FlxGame;

class InitState extends FlxGame {
  public function new() {
    // Create the menu state
    super(640, 480, MenuState, 1, 60, 60, true);

    // Load custom cursor and then hide hardware cursor
    FlxG.mouse.load(AssetPaths.cursor__png, 1, -7, -7);
    FlxG.mouse.visible = false;
  }
}
