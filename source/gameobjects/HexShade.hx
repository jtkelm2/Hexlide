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

class HexShade extends FlxSprite implements Movable
{
	public var isMoving:Bool;
	public var inLocale:Null<Locale<Movable>>;
	public var scale_x(default, set):Float;
	public var scale_y(default, set):Float;

	public var coords:Coords;

	public function new()
	{
		super();
		System.initMovable(this);
		loadGraphic("assets/hexShade.png", true, 2 * Reg.HEX_RADIUS, 2 * Reg.HEX_RADIUS, true);
		scale.x = 1.45;
		scale.y = 1.45;
		Reg.hexShadeGroup.add(this);
	}

	public function setCoords(coords:Coords, locale:HexPlaneLocale, callback:Callback = null)
	{
		this.coords = coords;
		locale.insert(coords, this, callback);
	}

	public function setFrameIndex(facings:Array<Facing>)
	{
		switch facings
		{
			case []:
				animation.frameIndex = 0;
			case [facing]:
				animation.frameIndex = 1;
				angle += (HexMap.facingInt(facing) + 1) * 60;
			case [NE, E]:
				animation.frameIndex = 2;
				angle += 60;
			case [E, SE]:
				animation.frameIndex = 2;
				angle += 120;
			case [SE, SW]:
				animation.frameIndex = 2;
				angle += 180;
			case [SW, W]:
				animation.frameIndex = 2;
				angle += 240;
			case [W, NW]:
				animation.frameIndex = 2;
				angle += 300;
			case [NE, NW]:
				animation.frameIndex = 2;
			case [NE, E, SE]:
				animation.frameIndex = 3;
				angle += 120;
			case [E, SE, SW]:
				animation.frameIndex = 3;
				angle += 180;
			case [SE, SW, W]:
				animation.frameIndex = 3;
				angle += 240;
			case [SW, W, NW]:
				animation.frameIndex = 3;
				angle += 300;
			case [NE, W, NW]:
				animation.frameIndex = 3;
			case [NE, E, NW]:
				animation.frameIndex = 3;
				angle += 60;
			case _:
				throw "setFrameIndex match error: " + facings;
		}
	}

	public function moveTo(x:Float, y:Float, ?callback:Callback)
	{
		System.effects.instantMove(this, x, y, callback);
	}

	public function rotate(angleDiff:Float, ?callback:Callback)
	{
		angle += angleDiff;
		if (callback != null)
			callback();
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
