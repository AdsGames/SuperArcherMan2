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
import ui.MenuNav;
import ui.PixelButton;

class MenuState extends FlxState {
  // Arrows
  private var emitter:FlxEmitter;

  public function new() {
    super();
  }

  // Init game
  override public function create() {
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
    add(new FlxSprite(150, 50, AssetPaths.title__png));
    var startButton = new PixelButton(650, 380, "Start Game", startGame);
    var helpButton = new PixelButton(650, 420, "Instructions", showHelp);
    add(startButton);
    add(helpButton);
    add(new MenuNav([startButton, helpButton]));
  }

  // Start music
  private function startMusic() {
    if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
      FlxG.sound.playMusic(AssetPaths.menu__mp3, 1, true);
    }
  }

  // Start
  private function startGame() {
    FlxG.switchState(() -> new LevelSelect());
  }

  // Help
  private function showHelp() {
    FlxG.switchState(() -> new HelpState());
  }
}
