package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;

class HelpState extends FlxState {
  // Create help state
  override public function create() {
    FlxG.mouse.visible = true;
    add(new FlxSprite(0, 0, AssetPaths.help__png));
    add(new FlxButton(105, 15, "Back", backMenu));
  }

  // Start
  private function backMenu() {
    FlxG.switchState(new MenuState());
  }
}
