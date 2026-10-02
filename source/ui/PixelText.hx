package ui;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;

// Bitmap text using flixel's built in 1-bit pixel font (no anti-aliasing)
class PixelText {
  public static function create(text:String = "", x:Float = 0, y:Float = 0, scale:Int = 1):FlxBitmapText {
    var bitmapText = new FlxBitmapText(x, y, text, FlxBitmapFont.getDefaultFont());
    bitmapText.useTextColor = true;
    bitmapText.textColor = 0xFFFFFFFF;
    bitmapText.antialiasing = false;
    bitmapText.scale.set(scale, scale);
    bitmapText.updateHitbox();
    return bitmapText;
  }
}
