package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import ui.MenuNav;
import ui.PixelButton;

class LevelSelect extends FlxState {
  private var backButton:PixelButton;

  private var backgroundImage:FlxSprite;

  private var level1Button:PixelButton;
  private var level2Button:PixelButton;
  private var level3Button:PixelButton;

  public function new() {
    super();
  }

  // Init game
  override public function create() {
    backgroundImage = new FlxSprite(0, 0, AssetPaths.level__png);
    add(backgroundImage);

    level1Button = new PixelButton(370, 270, "Enter", launchLevel1);
    level2Button = new PixelButton(130, 510, "Enter", launchLevel2);
    level3Button = new PixelButton(600, 510, "Enter", launchLevel3);
    backButton = new PixelButton(370, 550, "Back", backMenu);

    add(level1Button);
    add(level2Button);
    add(level3Button);
    add(backButton);

    add(new MenuNav([level1Button, level2Button, level3Button, backButton], backMenu));
  }

  // Back
  private function backMenu() {
    FlxG.switchState(() -> new MenuState());
  }

  // 1
  private function launchLevel1() {
    FlxG.sound.music.stop();
    FlxG.switchState(() -> new PlayState(1));
  }

  // 2
  private function launchLevel2() {
    FlxG.sound.music.stop();
    FlxG.switchState(() -> new PlayState(2));
  }

  // 3
  private function launchLevel3() {
    FlxG.sound.music.stop();
    FlxG.switchState(() -> new PlayState(3));
  }
}
