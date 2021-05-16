package allanly;

/**
 * Background
 * ALLAN AND SULLY!
 * Background handler
 * 14/6/2015
 */
// Libraries
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tile.FlxTileblock;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;

class Background extends FlxSprite {
  // Create
  public function new(path:String, offset:Int, baseOffset:Int, gradient1:String, gradient2:String) {
    super(0, 0);

    new FlxSprite(0, 0, path);

    // Add backgrounds
    createBackdrop(gradient1, gradient2);

    for (i in 0...6) {
      FlxG.state.add(spawnBackground(i, path, offset, baseOffset));
    }
  }

  public function createBackdrop(gradient1:String, gradient2:String) {
    var _sprSolid = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.fromString(gradient1), FlxColor.fromString(gradient2)], 8);
    _sprSolid.y = 0;
    _sprSolid.scrollFactor.set();
    FlxG.state.add(_sprSolid);
  }

  public function spawnBackground(pos:Int, path:String, offset:Int, baseOffset:Int):FlxTileblock {
    var mountain:FlxTileblock = new FlxTileblock(0, FlxG.height - (baseOffset + ((5 - pos) * offset)), Math.ceil(FlxG.width * 4), 116);
    mountain.loadTiles(bakeColors(FlxColor.WHITE.getDarkened(1 - (.2 + (pos * .1))), path), 256, 116, 0);
    mountain.scrollFactor.set(.2 + (pos * .1), 0);
    return mountain;
  }

  function bakeColors(color:FlxColor, asset:String, ?alpha:Float = 1):String {
    var bmpData:BitmapData = FlxG.bitmap.get(asset).bitmap.clone();

    var colorTransform:ColorTransform = new ColorTransform();
    colorTransform.redMultiplier = color.redFloat;
    colorTransform.greenMultiplier = color.greenFloat;
    colorTransform.blueMultiplier = color.blueFloat;
    colorTransform.alphaMultiplier = alpha;

    bmpData.colorTransform(bmpData.rect, colorTransform);
    var key:String = asset + "_color=" + color;
    FlxG.bitmap.add(bmpData, false, key);
    return key;
  }
}
