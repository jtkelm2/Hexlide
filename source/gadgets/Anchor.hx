package gadgets;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import system.*;
import system.Data;

class Anchor implements Locale<Movable> implements Movable
{
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var scale_x(default, set):Float;
	public var scale_y(default, set):Float;
	public var angle(default, set):Float;
	public var origin:FlxPoint;

	public var inLocale:Null<Locale<Movable>>;
	public var isMoving:Bool;

	var anchored:Array<Movable>;

	public function new(x:Float = 0, y:Float = 0)
	{
		this.anchored = [];
		this.x = x;
		this.y = y;
		scale_x = 1;
		scale_y = 1;
		angle = 0;
		origin = FlxPoint.get(0, 0);
		isMoving = false;
	}

	public function add(sprite:Movable, callback:Callback = null)
	{
		anchored.push(sprite);
		if (callback != null)
			callback();
	}

	public function remove(sprite:Movable, callback:Callback = null)
	{
		anchored.remove(sprite);
		if (callback != null)
			callback();
	}

	public function relativize(point:FlxPoint):FlxPoint
	{
		var home = FlxPoint.get(x, y);
		var displacement = point - home;
		displacement.degrees += angle;
		displacement.x *= scale_x;
		displacement.y *= scale_y;
		displacement += home;
		home.put();
		return displacement;
	}

	public function moveTo(x:Float, y:Float, callback:Callback = null)
	{
		System.effects.quadMove(this, x, y, callback);
	}

	public function rotate(angleDiff:Float, callback:Callback = null)
	{
		System.effects.quadRotate(this, angleDiff, callback);
	}

	// ---------------------------

	private function set_x(newX:Float)
	{
		if (x == null)
		{
			x = newX;
			return x;
		}

		var diffX = newX - x;
		for (sprite in anchored)
		{
			sprite.x += diffX;
		}
		x = newX;
		return x;
	}

	private function set_y(newY:Float)
	{
		if (y == null)
		{
			y = newY;
			return y;
		}

		var diffY = newY - y;
		for (sprite in anchored)
		{
			sprite.y += diffY;
		}
		y = newY;
		return y;
	}

	private function set_scale_x(newScale_x:Float)
	{
		if (scale_x == null)
		{
			scale_x = newScale_x;
			return scale_x;
		}

		var scaleQuotient = newScale_x / scale_x;
		for (sprite in anchored)
		{
			var displacementX = (sprite.x + sprite.origin.x) - x;
			displacementX *= scaleQuotient;
			sprite.x = x + displacementX - sprite.origin.x;

			sprite.scale_x *= scaleQuotient;
		}
		scale_x = newScale_x;
		return newScale_x;
	}

	private function set_scale_y(newScale_y:Float)
	{
		if (scale_y == null)
		{
			scale_y = newScale_y;
			return scale_y;
		}

		var scaleQuotient = newScale_y / scale_y;
		for (sprite in anchored)
		{
			var displacementY = (sprite.y + sprite.origin.y) - x;
			displacementY *= scaleQuotient;
			sprite.y = y + displacementY - sprite.origin.y;

			sprite.scale_y *= scaleQuotient;
		}
		scale_y = newScale_y;
		return newScale_y;
	}

	private function set_angle(newAngle:Float)
	{
		if (angle == null)
		{
			angle = newAngle;
			return newAngle;
		}
		var angleDiff = newAngle - angle;
		var anchorPoint = FlxPoint.get(x, y);
		// trace("AnchorPoint: " + anchorPoint);
		for (sprite in anchored)
		{
			var oldMidpoint = FlxPoint.get(sprite.x, sprite.y) + sprite.origin;
			var newMidpoint = FlxPoint.get(sprite.x, sprite.y) + sprite.origin;
			newMidpoint.pivotDegrees(anchorPoint, angleDiff);
			sprite.x += newMidpoint.x - oldMidpoint.x;
			sprite.y += newMidpoint.y - oldMidpoint.y;
			sprite.angle += angleDiff;
			// trace("Old: " + oldMidpoint);
			// trace("New: " + newMidpoint);
			oldMidpoint.put();
			newMidpoint.put();
		}
		anchorPoint.put();
		angle = newAngle;
		return newAngle;
	}
}
/* package gadgets;

	import flixel.FlxSprite;
	import flixel.math.FlxMath;
	import flixel.math.FlxPoint;
	import system.*;
	import system.Data;

	enum AnchorAST
	{
	Branch(anchor:Anchor);
	Leaf(sprite:Movable);
	}

	class Anchor implements Locale<Movable> implements Movable
	{
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var scale_x(default, set):Float;
	public var scale_y(default, set):Float;
	public var angle(default, set):Float;
	public var origin:FlxPoint;

	public var inLocale:Null<Locale<Movable>>;
	public var isMoving:Bool;

	var anchored:Array<AnchorAST>;

	public function new(x:Float = 0, y:Float = 0)
	{
		this.anchored = [];
		this.x = x;
		this.y = y;
		scale_x = 1;
		scale_y = 1;
		angle = 0;
		origin = FlxPoint.get(0, 0);
		isMoving = false;
	}

	public function add(sprite:Movable, callback:Callback = null)
	{
		anchored.push(Leaf(sprite));
		if (callback != null)
			callback();
	}

	public function remove(sprite:Movable, callback:Callback = null)
	{
		for (i in 0...anchored.length)
		{
			switch anchored[i]
			{
				case Leaf(otherSprite):
					if (sprite == otherSprite)
					{
						if (callback != null)
							callback();
						anchored.splice(i, 1);
						break;
					}
				case _:
			}
		}
	}

	public function addSubAnchor(anchor:Anchor)
	{
		anchored.push(Branch(anchor));
	}

	public function removeSubAnchor(anchor:Anchor)
	{
		for (i in 0...anchored.length)
		{
			switch anchored[i]
			{
				case Branch(otherAnchor):
					if (anchor == otherAnchor)
					{
						anchored.splice(i, 1);
						break;
					}
				case _:
			}
		}
	}

	public function relativize(point:FlxPoint):FlxPoint
	{
		var home = FlxPoint.get(x, y);
		var displacement = point - home;
		displacement.degrees += angle;
		displacement.x *= scale_x;
		displacement.y *= scale_y;
		displacement += home;
		home.put();
		return displacement;
	}

	public function moveTo(x:Float, y:Float, callback:Callback = null)
	{
		System.effects.quadMove(this, x, y, callback);
	}

	public function rotate(angleDiff:Float, callback:Callback = null)
	{
		System.effects.quadRotate(this, angleDiff, callback);
	}

	// ---------------------------

	private function set_x(newX:Float)
	{
		if (x == null)
		{
			x = newX;
			return x;
		}

		var diffX = newX - x;
		for (object in anchored)
		{
			switch object
			{
				case Leaf(sprite):
					sprite.x += diffX;
				case Branch(anchor):
					anchor.x += diffX;
			}
		}
		x = newX;
		return x;
	}

	private function set_y(newY:Float)
	{
		if (y == null)
		{
			y = newY;
			return y;
		}

		var diffY = newY - y;
		for (object in anchored)
		{
			switch object
			{
				case Leaf(sprite):
					sprite.y += diffY;
				case Branch(anchor):
					anchor.y += diffY;
			}
		}
		y = newY;
		return y;
	}

	private function set_scale_x(newScale_x:Float)
	{
		if (scale_x == null)
		{
			scale_x = newScale_x;
			return scale_x;
		}

		var scaleQuotient = newScale_x / scale_x;
		for (object in anchored)
		{
			switch object
			{
				case Leaf(sprite):
					var displacementX = (sprite.x + sprite.origin.x) - x;
					displacementX *= scaleQuotient;
					sprite.x = x + displacementX - sprite.origin.x;

					sprite.scale_x *= scaleQuotient;
				case Branch(anchor):
					anchor.scale_x *= scaleQuotient;
			}
		}
		scale_x = newScale_x;
		return newScale_x;
	}

	private function set_scale_y(newScale_y:Float)
	{
		if (scale_y == null)
		{
			scale_y = newScale_y;
			return scale_y;
		}

		var scaleQuotient = newScale_y / scale_y;
		for (object in anchored)
		{
			switch object
			{
				case Leaf(sprite):
					var displacementY = (sprite.y + sprite.origin.y) - x;
					displacementY *= scaleQuotient;
					sprite.y = y + displacementY - sprite.origin.y;

					sprite.scale_y *= scaleQuotient;
				case Branch(anchor):
					anchor.scale_y *= scaleQuotient;
			}
		}
		scale_y = newScale_y;
		return newScale_y;
	}

	private function set_angle(newAngle:Float)
	{
		if (angle == null)
		{
			angle = newAngle;
			return angle;
		}
		var angleDiff = newAngle - angle;
		for (object in anchored)
		{
			switch object
			{
				case Leaf(sprite):
					var oldMidpoint = FlxPoint.get(sprite.x, sprite.y) + sprite.origin;
					var newMidpoint = FlxPoint.get(sprite.x, sprite.y) + sprite.origin;
					var anchorPoint = FlxPoint.get(x, y);
					newMidpoint.pivotDegrees(anchorPoint, angleDiff);
					sprite.x += newMidpoint.x - oldMidpoint.x;
					sprite.y += newMidpoint.y - oldMidpoint.y;
					sprite.angle += angleDiff;
					oldMidpoint.put();
					newMidpoint.put();
					anchorPoint.put();
				case Branch(anchor):
					anchor.angle += angleDiff;
			}
		}
		angle = newAngle;
		return angle;
	}
}*/
