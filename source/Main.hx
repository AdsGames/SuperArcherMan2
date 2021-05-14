package;

// Imports
import openfl.display.Sprite;

// Initilize game and run
class Main extends Sprite {
  public function new() {
    super();
    addChild(new InitState());
  }
}
