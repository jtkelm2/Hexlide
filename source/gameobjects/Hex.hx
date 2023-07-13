package gameobjects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gadgets.*;
import map.*;
import system.*;
import system.Data;

class Hex extends FlxSprite implements Movable implements IDSprite
{
	public var isMoving:Bool;
	public var inLocale:Null<Locale<Movable>>;
	public var scale_x(default, set):Float;
	public var scale_y(default, set):Float;

	public var number:Int;
	public var coords:Coords;

	public var id:ObjectID;

	public function new(number:Int)
	{
		super();
		id = HexID(this);
		System.initMovable(this);
		System.mouse.initClickable(this);
		loadGraphic("assets/hex.png", true, 2 * Reg.HEX_RADIUS, 2 * Reg.HEX_RADIUS, true);
		scale.x = 0.9;
		scale.y = 0.9;
		alpha = 0.8;
		Reg.hexGroup.add(this);

		var text = new FlxText();
		text.setFormat("assets/BebasNeue-Regular.ttf");
		// text.setBorderStyle(OUTLINE, color.brightness > 0.5 ? FlxColor.BLACK : FlxColor.WHITE, 3);
		text.text = Std.string(number);
		text.color = Reg.UNSOLVED_COLOR;
		text.size = Math.round(1.15 * Reg.HEX_RADIUS);
		text.fieldWidth = 2 * Reg.HEX_RADIUS;
		text.alignment = CENTER;
		stamp(text, 0, Math.round((2 * Reg.HEX_RADIUS - text.height) / 2)); // stamp(text, 0, Math.round(0.55 * Reg.HEX_RADIUS));
		animation.frameIndex = 1;
		text.color = Reg.SOLVED_COLOR;
		stamp(text, 0, Math.round((2 * Reg.HEX_RADIUS - text.height) / 2));
		animation.frameIndex = 0;
		text.destroy();

		this.number = number;
	}

	public function setCoords(coords:Coords, locale:HexPlaneLocale, callback:Callback = null)
	{
		this.coords = coords;
		locale.insert(coords, this, callback);
	}

	public function toggleTint(bool:Bool)
	{
		animation.frameIndex = bool ? 1 : 0;
		// color = bool ? FlxColor.CYAN : FlxColor.GRAY;
	}

	public function moveTo(x:Float, y:Float, ?callback:Callback)
	{
		System.effects.quadMove(this, x, y, callback);
	}

	public function rotate(angleDiff:Float, ?callback:Callback)
	{
		System.effects.quadRotate(this, angleDiff, callback);
	}

	// -------------------------------

	private function set_scale_x(newScale_x:Float):Float
	{
		scale_x = newScale_x;
		scale.x = newScale_x;
		return newScale_x;
	}

	private function set_scale_y(newScale_y:Float):Float
	{
		scale_y = newScale_y;
		scale.y = newScale_y;
		return newScale_y;
	}
}
