package;

/**
 * ALLAN AND SULLY!
 * Creator of game state
 * 5/28/2015
 */
// Imports
import allanly.Controls;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.StageQuality;

class InitState extends FlxGame {
  public function new() {
    // Create the menu state
    super(800, 600, MenuState, 60, 60, true);

    // OpenFL smooths plain bitmaps like the cursor when the stage is scaled up, keep pixels sharp
    Lib.current.stage.quality = StageQuality.LOW;

    // Load custom cursor and then hide hardware cursor
    FlxG.mouse.load(AssetPaths.cursor__png, 1, -7, -7);
    FlxG.sound.volume = 1.0;

    // Track keyboard / mouse vs gamepad, also sets cursor visibility
    FlxG.signals.preUpdate.add(Controls.update);
  }
}
