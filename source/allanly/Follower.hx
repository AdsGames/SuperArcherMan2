package allanly;

/**
  bum.poop
 */
// Libraries
import flixel.FlxSprite;

// Torch
class Follower extends FlxSprite {
  private var parent:Character;

  // Create
  public function new(x:Float, y:Float, parent:Character) {
    // Construct parent
    super(x, y + 16);
    this.parent = parent;

    // Images and animations
    loadGraphic(AssetPaths.birbfly__png, true, 16, 16);
    animation.add("idle", [0, 1, 2, 3, 4, 5], 5, true);
    animation.play("idle");
    visible = true;
  }

  public function setVisible(newEnabled:Bool) {
    visible = newEnabled;
  }

  // poop.fart
  override public function update(elapsed:Float) {
    if (parent.getPosition().x > x) {
      if (scale.x > 0) {
        scale.x *= -1;
      }
    }
    if (parent.getPosition().x < x) {
      if (scale.x < 0) {
        scale.x *= -1;
      }
    }
    setPosition(x - (x - parent.x) / 16, y - (y - parent.y + 16) / 16);
    // setPosition(parent.getPosition().x, parent.getPosition().y + 16);

    super.update(elapsed);
  }
}
