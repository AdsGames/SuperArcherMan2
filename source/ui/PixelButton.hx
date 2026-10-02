package ui;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxBitmapText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

// Colors for one button state
typedef ButtonStyle = {
  outline:FlxColor,
  face:FlxColor,
  light:FlxColor,
  shadow:FlxColor,
  text:FlxColor
}

// FlxButton with pixel art wood frames and a 1-bit bitmap font label, stays crisp when the game is scaled
class PixelButton extends FlxTypedButton<FlxBitmapText> {
  private static inline final BUTTON_WIDTH:Int = 80;
  private static inline final BUTTON_HEIGHT:Int = 20;
  private static inline final GRAPHIC_KEY:String = "ui.PixelButton";

  // One style per FlxButtonState, in NORMAL, HIGHLIGHT, PRESSED, DISABLED order
  private static final STYLES:Array<ButtonStyle> = [
    // Dark wood, parchment text
    {
      outline: 0xFF1B0C03,
      face: 0xFF7A3A10,
      light: 0xFFA85A22,
      shadow: 0xFF4A2006,
      text: 0xFFF3E2C0
    },
    // Gold outline, lighter wood, white text
    {
      outline: 0xFFFFCC33,
      face: 0xFFB0561A,
      light: 0xFFE08A40,
      shadow: 0xFF6A300C,
      text: 0xFFFFFFFF
    },
    // Inverted bevel, pushed in
    {
      outline: 0xFFFFCC33,
      face: 0xFF5A2808,
      light: 0xFF3A1804,
      shadow: 0xFF8A4416,
      text: 0xFFE8C890
    },
    // Greyed out
    {
      outline: 0xFF2A2A2A,
      face: 0xFF5A5A5A,
      light: 0xFF707070,
      shadow: 0xFF404040,
      text: 0xFF9A9A9A
    }
  ];

  // Selected by keyboard / gamepad navigation, shows as highlighted
  public var focused:Bool = false;

  public function new(x:Float = 0, y:Float = 0, text:String, ?onClick:Void->Void) {
    super(x, y, onClick);

    loadGraphic(getGraphic(), true, BUTTON_WIDTH, BUTTON_HEIGHT);

    // State shows through color, not label alpha
    labelAlphas = [1, 1, 1, 1];

    var newLabel = PixelText.create(text);
    newLabel.autoSize = false;
    newLabel.fieldWidth = Std.int(width);
    newLabel.alignment = CENTER;

    // Center label vertically on the button face (+1 as the face sits below the top border)
    var offsetY = Math.floor((height - newLabel.height) / 2) + 1;
    for (point in labelOffsets) {
      point.set(point.x, point.y + offsetY);
    }

    label = newLabel;
    label.textColor = STYLES[status.toInt()].text;
  }

  // Keep focus highlight when the mouse is not over the button
  override function updateButton() {
    if (focused && status == HIGHLIGHT && !checkMouseOverlap()) {
      return;
    }

    super.updateButton();

    if (focused && status == NORMAL) {
      status = HIGHLIGHT;
    }
  }

  // Label color follows state (runs in super() before the label exists)
  override function set_status(value:FlxButtonState):FlxButtonState {
    super.set_status(value);
    if (label != null) {
      label.textColor = STYLES[status.toInt()].text;
    }
    return status;
  }

  // Activate as if clicked
  public function press() {
    onUp.fire();
  }

  // Frames for all states, drawn once and shared by every button
  private static function getGraphic():FlxGraphic {
    var graphic = FlxG.bitmap.get(GRAPHIC_KEY);
    if (graphic != null) {
      return graphic;
    }

    var bitmap = new BitmapData(BUTTON_WIDTH * STYLES.length, BUTTON_HEIGHT, true, FlxColor.TRANSPARENT);
    for (i in 0...STYLES.length) {
      paintFrame(bitmap, i * BUTTON_WIDTH, STYLES[i]);
    }

    graphic = FlxG.bitmap.add(bitmap, false, GRAPHIC_KEY);
    graphic.persist = true;
    return graphic;
  }

  // Outline with cut corners, face, light bevel top / left, shadow bevel bottom / right
  private static function paintFrame(bitmap:BitmapData, offsetX:Int, style:ButtonStyle) {
    var w = BUTTON_WIDTH;
    var h = BUTTON_HEIGHT;

    bitmap.fillRect(new Rectangle(offsetX, 0, w, h), style.outline);
    bitmap.fillRect(new Rectangle(offsetX + 1, 1, w - 2, h - 2), style.face);

    bitmap.fillRect(new Rectangle(offsetX + 1, 1, w - 2, 1), style.light);
    bitmap.fillRect(new Rectangle(offsetX + 1, 1, 1, h - 2), style.light);
    bitmap.fillRect(new Rectangle(offsetX + 1, h - 2, w - 2, 1), style.shadow);
    bitmap.fillRect(new Rectangle(offsetX + w - 2, 1, 1, h - 2), style.shadow);

    // Cut corners
    bitmap.setPixel32(offsetX, 0, FlxColor.TRANSPARENT);
    bitmap.setPixel32(offsetX + w - 1, 0, FlxColor.TRANSPARENT);
    bitmap.setPixel32(offsetX, h - 1, FlxColor.TRANSPARENT);
    bitmap.setPixel32(offsetX + w - 1, h - 1, FlxColor.TRANSPARENT);
  }
}
