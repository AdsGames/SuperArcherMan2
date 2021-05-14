package allanly;

/*
 * Sword
 * ALLAN AND SULLY!
 * Our main character, jim's, sword
 * 29/5/2015
 */
// Imports
import flixel.FlxObject;

class Sword extends Arm {
  // Variables
  private var idle:Bool;
  private var spinDir:String;

  // Parent
  private var parent:FlxObject;

  // Create bow
  public function new() {
    super(AssetPaths.sword_arm__png);

    idle = false;
    spinDir = "none";
  }

  // Update bow
  override public function update(elapsed:Float) {
    super.update(elapsed);

    // Spin that sword
    if (spinDir == "right") {
      angle += 30;
    }
    else if (spinDir == "left") {
      angle -= 30;
    }
  }

  // Change location
  override public function setPosition(x:Float = 0, y:Float = 0) {
    super.setPosition(x + 5, y - 8);
  }

  // SEt dir of spin
  public function setSpinDir(spinDir:String) {
    this.spinDir = spinDir;
  }
}
