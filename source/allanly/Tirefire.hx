package allanly;

/**
 * Snazzy animated paintint
 * ALLAN AND SULLY!
 * Nice painting
 * 11/6/2015
 */
// Libraries
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;

// Torch
class Tirefire extends FlxSprite {
  public var trailEmitter:FlxEmitter;
  public var fireParticle:FlxEmitter;

  // Create
  public function new(x:Float, y:Float) {
    // Construct parent
    super(x, y);

    // Images and animations
    loadGraphic(AssetPaths.tirefire__png, true, 64, 32);
    trailEmitter = new FlxEmitter(x + 32, y + 22, 100);
    trailEmitter.loadParticles(AssetPaths.smoke_Particle__png, 100);
    trailEmitter.scale.set(1, 1, 1, 1, 0, 0, 0, 0);
    trailEmitter.launchMode = FlxEmitterMode.CIRCLE;
    trailEmitter.speed.set(5, 5);
    trailEmitter.acceleration.set(3, -25.0, 4);
    trailEmitter.lifespan.set(15);
    trailEmitter.start(false, 0.05, 0);
    FlxG.state.add(trailEmitter);
    trailEmitter.emitting = true;

    fireParticle = new FlxEmitter(x + 32, y + 22, 50);
    fireParticle.loadParticles(AssetPaths.flame_particle__png, 100);
    fireParticle.scale.set(1, 1, 1, 1, 0, 0, 0, 0);
    fireParticle.launchMode = FlxEmitterMode.CIRCLE;
    fireParticle.speed.set(5, 25);
    fireParticle.acceleration.set(0, -20);
    fireParticle.lifespan.set(1);
    fireParticle.start(false, 0.03, 0);
    FlxG.state.add(fireParticle);
    fireParticle.emitting = true;
  }
}
