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
class Campfire extends FlxSprite {
  public var trailEmitter:FlxEmitter;
  public var fireParticle:FlxEmitter;

  // Create
  public function new(x:Float, y:Float) {
    // Construct parent
    super(x, y);

    // Images and animations
    loadGraphic(AssetPaths.campfire__png, true, 16, 16);
    trailEmitter = new FlxEmitter(x + 8, y + 8, 100);
    trailEmitter.loadParticles(AssetPaths.smoke_Particle__png, 100);
    trailEmitter.scale.set(1, 1, 1, 1, 0, 0, 0, 0);
    trailEmitter.launchMode = FlxEmitterMode.CIRCLE;
    trailEmitter.speed.set(5, 5);
    trailEmitter.acceleration.set(0, -25, 4);
    trailEmitter.lifespan.set(10);
    trailEmitter.start(false, 0.1, 0);
    FlxG.state.add(trailEmitter);
    trailEmitter.emitting = true;

    fireParticle = new FlxEmitter(x + 8, y + 8, 50);
    fireParticle.loadParticles(AssetPaths.flame_particle__png, 100);
    fireParticle.scale.set(1, 1, 1, 1, 0, 0, 0, 0);
    fireParticle.launchMode = FlxEmitterMode.CIRCLE;
    fireParticle.speed.set(5, 25);
    fireParticle.acceleration.set(0, -20);
    fireParticle.lifespan.set(1);
    fireParticle.start(false, 0.04, 0);
    FlxG.state.add(fireParticle);
    fireParticle.emitting = true;
  }
}
