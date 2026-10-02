package allanly;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

// Combined keyboard / mouse and gamepad input
class Controls {
  // Right stick must move this far to aim
  private static inline final AIM_DEADZONE:Float = 0.2;

  // Stick length past this counts as a full push, many sticks never reach 1
  private static inline final AIM_OUTER_DEADZONE:Float = 0.95;

  // Stick length dropping faster than this per frame means it was let go
  private static inline final AIM_RELEASE_DROP:Float = 0.25;

  // Ignore the stick for this long (seconds) after it is let go
  private static inline final AIM_RELEASE_HOLD:Float = 0.1;

  // Aim turn speed (per second) for a light and a full push, light push allows fine aim
  private static inline final AIM_TURN_RATE_MIN:Float = 8;
  private static inline final AIM_TURN_RATE_MAX:Float = 30;

  // Distance from the bow to the gamepad aim point
  private static inline final AIM_DISTANCE:Float = 120.0;

  // World position being aimed at
  public static var aim(default, null):FlxPoint = FlxPoint.get();

  // Last input came from a gamepad
  public static var usingGamepad(default, null):Bool = false;

  // Aim with the right stick until the mouse moves again
  public static var gamepadAim(default, null):Bool = false;

  // Smoothed gamepad aim in degrees, null until the stick is first used
  private static var aimAngle:Null<Float> = null;

  // Stick springs back through the centre when let go, ignore it briefly
  private static var aimHeldFor:Float = 0;
  private static var lastAimLength:Float = 0;

  // Track input device, call once from FlxG.signals.preUpdate
  public static function update() {
    #if FLX_GAMEPAD
    for (gamepad in FlxG.gamepads.getActiveGamepads()) {
      // Independent axes snap shallow stick angles flat, bad for aiming
      gamepad.deadZoneMode = CIRCULAR;

      if (gamepad.anyButton(JUST_PRESSED) || stickMoved(gamepad, LEFT_ANALOG_STICK) || stickMoved(gamepad, RIGHT_ANALOG_STICK)) {
        usingGamepad = true;
      }
    }
    #end

    #if FLX_KEYBOARD
    if (FlxG.keys.justPressed.ANY) {
      usingGamepad = false;
    }
    #end

    #if FLX_MOUSE
    if (FlxG.mouse.justMoved || FlxG.mouse.justPressed) {
      usingGamepad = false;
    }

    // Hide the cursor while playing with a gamepad
    FlxG.mouse.visible = !usingGamepad;
    #end
  }

  #if FLX_GAMEPAD
  private static function stickMoved(gamepad:FlxGamepad, stick:FlxGamepadInputID):Bool {
    var axes = gamepad.getAnalogAxes(stick);
    var moved = axes.length > AIM_DEADZONE;
    axes.put();
    return moved;
  }
  #end

  public static function pressed(keys:Array<FlxKey>, buttons:Array<FlxGamepadInputID>):Bool {
    #if FLX_KEYBOARD
    if (FlxG.keys.anyPressed(keys)) {
      return true;
    }
    #end

    #if FLX_GAMEPAD
    for (button in buttons) {
      if (FlxG.gamepads.anyPressed(button)) {
        return true;
      }
    }
    #end

    return false;
  }

  public static function justPressed(keys:Array<FlxKey>, buttons:Array<FlxGamepadInputID>):Bool {
    #if FLX_KEYBOARD
    if (FlxG.keys.anyJustPressed(keys)) {
      return true;
    }
    #end

    #if FLX_GAMEPAD
    for (button in buttons) {
      if (FlxG.gamepads.anyJustPressed(button)) {
        return true;
      }
    }
    #end

    return false;
  }

  // Movement, key is the keyboard binding for that direction
  public static function left(key:FlxKey):Bool {
    return pressed([key], [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT]);
  }

  public static function right(key:FlxKey):Bool {
    return pressed([key], [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT]);
  }

  public static function up(key:FlxKey):Bool {
    return pressed([key], [DPAD_UP, LEFT_STICK_DIGITAL_UP]);
  }

  public static function down(key:FlxKey):Bool {
    return pressed([key], [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN]);
  }

  public static function jump():Bool {
    return pressed([SPACE], [A, LEFT_TRIGGER]);
  }

  public static function toggleDrone():Bool {
    return justPressed([F], [Y]);
  }

  public static function nextBow():Bool {
    return justPressed([], [RIGHT_SHOULDER]);
  }

  public static function previousBow():Bool {
    return justPressed([], [LEFT_SHOULDER]);
  }

  public static function menu():Bool {
    return pressed([ESCAPE], [START]);
  }

  public static function suicide():Bool {
    return pressed([K], [BACK]);
  }

  public static function fireJustPressed():Bool {
    #if FLX_MOUSE
    if (FlxG.mouse.justPressed) {
      return true;
    }
    #end
    return justPressed([], [RIGHT_TRIGGER]);
  }

  public static function fireJustReleased():Bool {
    #if FLX_MOUSE
    if (FlxG.mouse.justReleased) {
      return true;
    }
    #end

    #if FLX_GAMEPAD
    if (FlxG.gamepads.anyJustReleased(RIGHT_TRIGGER)) {
      return true;
    }
    #end

    return false;
  }

  // Update aim point from the mouse, or the right stick around the origin
  public static function updateAim(originX:Float, originY:Float):FlxPoint {
    #if FLX_MOUSE
    if (FlxG.mouse.justMoved) {
      gamepadAim = false;
    }
    #end

    #if FLX_GAMEPAD
    var gamepad = FlxG.gamepads.lastActive;
    if (gamepad != null) {
      var stick = gamepad.getAnalogAxes(RIGHT_ANALOG_STICK);
      var push = readStickPush(stick.length);
      if (push > 0) {
        turnAim(stick.degrees, push);
      }
      stick.put();
    }
    #end

    if (gamepadAim) {
      var radians = (aimAngle : Float) * FlxAngle.TO_RAD;
      aim.set(originX + Math.cos(radians) * AIM_DISTANCE, originY + Math.sin(radians) * AIM_DISTANCE);
    }
    #if FLX_MOUSE
    else {
      aim.set(FlxG.mouse.x, FlxG.mouse.y);
    }
    #end

    return aim;
  }

  // Stick push from 0 (in deadzone or just let go) to 1 (full), call once per frame
  private static function readStickPush(length:Float):Float {
    aimHeldFor = Math.max(aimHeldFor - FlxG.elapsed, 0);
    if (length < lastAimLength - AIM_RELEASE_DROP) {
      aimHeldFor = AIM_RELEASE_HOLD;
    }
    lastAimLength = length;

    if (length <= AIM_DEADZONE || aimHeldFor > 0) {
      return 0;
    }
    return Math.min((length - AIM_DEADZONE) / (AIM_OUTER_DEADZONE - AIM_DEADZONE), 1);
  }

  // Turn smoothed aim towards the stick, faster the further it is pushed
  private static function turnAim(stickAngle:Float, push:Float) {
    // Snap on first use, or when coming back from the mouse
    if (aimAngle == null || !gamepadAim) {
      aimAngle = stickAngle;
      gamepadAim = true;
      return;
    }

    var current:Float = aimAngle;
    var rate = AIM_TURN_RATE_MIN + (AIM_TURN_RATE_MAX - AIM_TURN_RATE_MIN) * push;
    var amount = 1 - Math.exp(-rate * FlxG.elapsed);

    // Short way round
    var difference = ((stickAngle - current) % 360 + 540) % 360 - 180;
    aimAngle = current + difference * amount;
  }
}
