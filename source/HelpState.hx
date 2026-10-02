package;

import allanly.Controls;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import ui.MenuNav;
import ui.PixelButton;
import ui.PixelText;

class HelpState extends FlxState {
  // Matches the help image background
  private static inline final PANEL_COLOR:Int = 0xFFDD7E6B;
  private static inline final TEXT_COLOR:Int = 0xFF222222;

  // Covers the keyboard controls in the help image
  private var gamepadHelp:FlxGroup;

  // Create help state
  override public function create() {
    add(new FlxSprite(0, 0, AssetPaths.help__png));
    createGamepadHelp();

    var backButton = new PixelButton(105, 15, "Back", backMenu);
    add(backButton);
    add(new MenuNav([backButton], backMenu));
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);
    gamepadHelp.visible = Controls.usingGamepad;
  }

  // Gamepad mapping drawn over the keyboard controls
  private function createGamepadHelp() {
    gamepadHelp = new FlxGroup();

    // Controls block, down to the "F: Deploy" line
    gamepadHelp.add(new FlxSprite(20, 55).makeGraphic(760, 370, PANEL_COLOR));
    var lines = [
      "Right Stick: Aim bow",
      "Right Trigger: Hold to charge up bow. Release to fire",
      "Left Trigger / A: Jump",
      "Left Stick / D-Pad: Move Jim (the player)",
      "Left Stick / D-Pad: Move Jim (the bird) when deployed",
      "Y: Deploy and collect Jim (the bird)",
      "Start: Back to menu",
      "Back: Give up"
    ];
    for (i in 0...lines.length) {
      gamepadHelp.add(createText(lines[i], 33, 70 + i * 40));
    }

    // "Keys 1-4" line, leaves the bow icons visible
    gamepadHelp.add(new FlxSprite(20, 435).makeGraphic(285, 35, PANEL_COLOR));
    gamepadHelp.add(createText("LB / RB: Change bow", 33, 444));

    gamepadHelp.visible = Controls.usingGamepad;
    add(gamepadHelp);
  }

  private function createText(text:String, x:Float, y:Float) {
    var line = PixelText.create(text, x, y, 2);
    line.textColor = TEXT_COLOR;
    return line;
  }

  // Start
  private function backMenu() {
    FlxG.switchState(() -> new MenuState());
  }
}
