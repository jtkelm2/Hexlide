package gadgets;

import flixel.math.FlxPoint;
import map.*;
import system.*;
import system.Data;

using Useful;

class HexPlaneLocale implements Locale<Movable> implements Movable
{
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var origin:FlxPoint;
	public var scale_x(default, set):Float;
	public var scale_y(default, set):Float;
	public var angle(default, set):Float;

	private var size:Float;

	private var objects:Map<Coords, Movable>;
	private var objectsCoords:Map<Movable, Coords>;
	private var anchor:Anchor;

	public var inLocale:Null<Locale<Movable>>;
	public var isMoving:Bool;

	public function new(x:Float, y:Float, size:Float)
	{
		System.initMovable(this);
		origin = FlxPoint.get(0, 0);
		anchor = new Anchor(x, y);

		this.x = x;
		this.y = y;

		this.size = size;

		objects = [];
		objectsCoords = [];
	}

	public function insert(coords:Coords, object:Movable, ?callback:Callback)
	{
		var newCallback = () ->
		{
			anchor.add(object);
			if (callback != null)
				callback();
		}

		if (objects[coords] != null)
		{
			remove(objects[coords]);
		}

		if (object.inLocale != null)
		{
			object.inLocale.remove(object);
		}

		object.inLocale = this;
		objects[coords] = object;
		objectsCoords[object] = coords;

		var dest = getPosition(coords);
		object.moveTo(dest.x, dest.y, newCallback);
		dest.put();
	}

	public function popOutToward(object:Movable, towardCoords1:Coords, towardCoords2:Coords, callback:Callback = null)
	{
		if (objectsCoords == null)
		{
			throw "Null objectsCoords";
		}
		if (!objectsCoords.exists(object))
		{
			throw "DNE objectsCoords[object]";
		}
		var coords = objectsCoords[object];
		remove(object);
		var dest = (getPosition(coords) + getPosition(towardCoords1) + getPosition(towardCoords2)) / 3;
		object.moveTo(dest.x, dest.y, callback);
		dest.put();
	}

	public function remove(object:Movable, callback:Callback = null)
	{
		objects[objectsCoords[object]] = null;
		objectsCoords[object] = null;
		object.inLocale = null;
		anchor.remove(object, callback);
	}

	public inline function getPosition(coords:Coords):FlxPoint
	{
		return anchor.relativize(FlxPoint.weak(x, y) + HexMap.toCart(coords, size));
	}

	public function moveTo(x:Float, y:Float, callback:Callback = null)
	{
		System.effects.quadMove(this, x, y, callback);
	}

	public function rotate(angleDiff:Float, callback:Callback = null)
	{
		System.effects.quadRotate(this, angleDiff, callback);
	}

	// ------------------------------------

	private function set_x(newX:Float):Float
	{
		if (x == null)
		{
			x = newX;
			return newX;
		}
		var diffX = newX - x;
		x = newX;
		anchor.x += diffX;
		return newX;
	}

	private function set_y(newY:Float):Float
	{
		if (y == null)
		{
			y = newY;
			return newY;
		}
		var diffY = newY - y;
		y = newY;
		anchor.y += diffY;
		return newY;
	}

	private function set_scale_x(newScale_x:Float):Float
	{
		if (scale_x == null)
		{
			scale_x = newScale_x;
			return newScale_x;
		}
		var scaleQuot = newScale_x / scale_x;
		scale_x = newScale_x;
		anchor.scale_x *= scaleQuot;
		return newScale_x;
	}

	private function set_scale_y(newScale_y:Float):Float
	{
		if (scale_y == null)
		{
			scale_y = newScale_y;
			return newScale_y;
		}
		var scaleQuot = newScale_y / scale_y;
		scale_y = newScale_y;
		anchor.scale_y *= scaleQuot;
		return newScale_y;
	}

	private function set_angle(newAngle:Float):Float
	{
		if (angle == null)
		{
			angle = newAngle;
			return newAngle;
		}
		var angleDiff = newAngle - angle;
		angle = newAngle;
		anchor.angle += angleDiff;
		return newAngle;
	}
}
