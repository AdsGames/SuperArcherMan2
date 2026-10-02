package ui;

import allanly.Controls;
import flixel.FlxBasic;

// Keyboard and gamepad navigation between PixelButtons
class MenuNav extends FlxBasic {
  private var buttons:Array<PixelButton>;
  private var selected:Int = -1;
  private var onBack:Void->Void;

  // Flixel resets input on state switch, so a held button reads as just pressed again.
  // Ignore accept and back until they are let go, or one press runs through every menu.
  private var waitForRelease:Bool = true;

  public function new(buttons:Array<PixelButton>, ?onBack:Void->Void) {
    super();
    this.buttons = buttons;
    this.onBack = onBack;

    for (i in 0...buttons.length) {
      // Mouse hover moves focus too
      buttons[i].onOver.callback = () -> select(i);
    }

    select(0);
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);

    if (buttons.length == 0) {
      return;
    }

    if (waitForRelease) {
      waitForRelease = Controls.pressed([ENTER, SPACE, ESCAPE, BACKSPACE], [ACCEPT, START, CANCEL]);
      return;
    }

    if (Controls.justPressed([UP, W], [DPAD_UP, LEFT_STICK_DIGITAL_UP])) {
      move(0, -1);
    }
    else if (Controls.justPressed([DOWN, S], [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN])) {
      move(0, 1);
    }
    else if (Controls.justPressed([LEFT, A], [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT])) {
      move(-1, 0);
    }
    else if (Controls.justPressed([RIGHT, D], [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT])) {
      move(1, 0);
    }
    else if (Controls.justPressed([ENTER, SPACE], [ACCEPT, START])) {
      buttons[selected].press();
    }
    else if (onBack != null && Controls.justPressed([ESCAPE, BACKSPACE], [CANCEL])) {
      onBack();
    }
  }

  private function select(index:Int) {
    if (selected >= 0) {
      buttons[selected].focused = false;
    }
    selected = index;
    buttons[selected].focused = true;
  }

  // Focus the nearest button in the given direction
  private function move(dirX:Int, dirY:Int) {
    var current = buttons[selected].getMidpoint();
    var best = -1;
    var bestScore = Math.POSITIVE_INFINITY;

    for (i in 0...buttons.length) {
      if (i == selected) {
        continue;
      }

      var point = buttons[i].getMidpoint();
      var dx = point.x - current.x;
      var dy = point.y - current.y;
      point.put();

      // Distance along the direction, and off to the side of it
      var forward = dx * dirX + dy * dirY;
      var side = Math.abs(dx * dirY - dy * dirX);
      if (forward <= 0) {
        continue;
      }

      // Prefer buttons in line with the direction
      var score = forward + side * 2;
      if (score < bestScore) {
        bestScore = score;
        best = i;
      }
    }

    current.put();

    if (best >= 0) {
      select(best);
    }
  }
}
