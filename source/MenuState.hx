package;

/**
 * ALLAN AND SULLY!
 * The Menu
 * 5/28/2015
 */
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.ui.FlxButton;

class MenuState extends FlxState {
  // Arrows
  private var emitter:FlxEmitter;

  public function new() {
    super();
  }

  // Init game
  override public function create() {
    FlxG.mouse.visible = true;

    createEmitter();
    createUI();
    startMusic();
  }

  // Create emitter
  private function createEmitter() {
    emitter = new FlxEmitter(0, 0);
    emitter.width = FlxG.width;
    emitter.height = FlxG.height;
    emitter.angularVelocity.set(50, 400);

    for (i in 0...100) {
      var particle = new FlxParticle();
      particle.loadGraphic(AssetPaths.arrow__png);
      particle.exists = false;
      emitter.add(particle);
    }

    emitter.start(false, 0.1);
    add(emitter);
  }

  // Create UI
  private function createUI() {
    add(new FlxSprite(0, 0, AssetPaths.menu__png));
    add(new FlxButton(280, 380, "Start Game", startGame));
    add(new FlxButton(280, 420, "Instructions", showHelp));
  }

  // Start music
  private function startMusic() {
    if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
      FlxG.sound.playMusic(AssetPaths.menu__mp3, 1, true);
    }
  }

  // Start
  private function startGame() {
    FlxG.mouse.visible = false;
    FlxG.switchState(new LevelSelect());
  }

  // Help
  private function showHelp() {
    FlxG.switchState(new HelpState());
  }
}
