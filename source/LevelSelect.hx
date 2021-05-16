package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;

class LevelSelect extends FlxState {
  private var backButton:FlxButton;

  private var backgroundImage:FlxSprite;

  private var level1Button:FlxButton;
  private var level2Button:FlxButton;
  private var level3Button:FlxButton;

  public function new() {
    super();
  }

  // Init game
  override public function create() {
    FlxG.mouse.visible = true;

    backgroundImage = new FlxSprite(0, 0, AssetPaths.level__png);
    add(backgroundImage);

    level1Button = new FlxButton(370, 270, "Enter", launchLevel1);
    level2Button = new FlxButton(130, 510, "Enter", launchLevel2);
    level3Button = new FlxButton(600, 510, "Enter", launchLevel3);
    backButton = new FlxButton(370, 550, "Back", backMenu);

    add(level1Button);
    add(level2Button);
    add(level3Button);
    add(backButton);
  }

  // Back
  private function backMenu() {
    FlxG.switchState(new MenuState());
  }

  // 1
  private function launchLevel1() {
    FlxG.sound.music.stop();
    FlxG.switchState(new PlayState(1));
  }

  // 2
  private function launchLevel2() {
    FlxG.sound.music.stop();
    FlxG.switchState(new PlayState(2));
  }

  // 3
  private function launchLevel3() {
    FlxG.sound.music.stop();
    FlxG.switchState(new PlayState(3));
  }
}
