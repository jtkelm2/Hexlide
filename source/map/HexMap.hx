package map;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import gadgets.*;
import gameobjects.*;
import system.*;
import system.Data;

using Lambda;
using Useful;

class HexMap
{
	public var originalX:Float;
	public var originalY:Float;
	public var x:Float;
	public var y:Float;

	public var hexes:Array<Hex>;
	public var hexAt:Map<Coords, Hex>;
	public var hexSlots:Array<Coords>;
	public var unoccupiedHexSlots:Array<Coords>;

	public static var directions:Map<Facing, Coords>;

	private var locale:HexPlaneLocale;

	public function new(x:Float, y:Float, hexSlots:Array<Coords>)
	{
		originalX = x;
		originalY = y;

		directions = [for (facing in Type.allEnums(Facing)) facing => facingCoords(facing)];
		locale = new HexPlaneLocale(x, y, Reg.HEX_RADIUS);

		loadLevel(hexSlots);
	}

	public function loadLevel(hexSlots:Array<Coords>)
	{
		if (hexes == null)
		{
			hexes = [];
		}
		this.hexSlots = hexSlots;
		this.hexSlots.sort(coordComparison);
		centerXY();

		for (hexShade in Reg.hexShadeGroup.members)
		{
			// hexShade.kill();
			Reg.hexShadeGroup.remove(hexShade, true);
			hexShade.destroy();
		}
		Reg.hexShadeGroup.clear();

		for (hex in Reg.hexGroup.members)
		{
			// hex.kill();
			Reg.hexGroup.remove(hex, true);
			hex.destroy();
		}
		Reg.hexGroup.clear();
		hexes = [];

		hexAt = [];
		unoccupiedHexSlots = hexSlots.copy();
		for (i in 1...hexSlots.length - 1)
		{
			newHexAt(hexSlots[i - 1], i);
		}
		shadeSlots();
	}

	public function newHexAt(coords:Coords, number:Int)
	{
		var hex = new Hex(number);
		hexes.push(hex);
		teleportHexTo(hex, coords);
	}

	public function teleportHexTo(hex:Hex, coords:Coords)
	{
		var pos = locale.getPosition(coords);
		hex.x = pos.x;
		hex.y = pos.y;
		pos.put();

		hex.setCoords(coords, locale);
		unoccupiedHexSlots.remove(hex.coords);
		hexAt[coords] = hex;
		hex.toggleTint(hex.coords == hexSlots[hex.number - 1]);
	}

	public function moveHexTo(hex:Hex, coords:Coords, callback:Callback = null)
	{
		var newCallback = () ->
		{
			unoccupiedHexSlots.remove(hex.coords);
			hexAt[coords] = hex;
			hex.toggleTint(hex.coords == hexSlots[hex.number - 1]);
			if (callback != null)
				callback();
		}
		hex.setCoords(coords, locale, newCallback);
	}

	public function canBudge(hex:Hex):Bool
	{
		for (coords in unoccupiedHexSlots)
		{
			if (!areAdjacent(hex.coords, coords))
				return false;
		}
		return true;
	}

	public function budgeHex(hex:Hex, callback:Callback = null)
	{
		var newCallback = () ->
		{
			unoccupiedHexSlots.push(hex.coords);
			hexAt.remove(hex.coords);
			if (callback != null)
				callback();
		}
		hex.toggleTint(false);
		if (unoccupiedHexSlots.length < 2)
		{
			throw "unoccupiedHexSlots.length < 2";
		}
		locale.popOutToward(hex, unoccupiedHexSlots[0], unoccupiedHexSlots[1], newCallback);
	}

	public function instantShuffle(callback:Callback = null)
	{
		var hexesShuffled:Int = 0;
		var newCallback = () ->
		{
			hexesShuffled++;
			if (hexesShuffled == hexes.length)
			{
				var occupied = hexes.map(hex -> hex.coords);
				unoccupiedHexSlots = hexSlots.filter(slot -> !occupied.contains(slot));
				if (callback != null)
					callback();
			}
		}
		var perm = makeEven(randomPerm(hexes.length), hexes.length);
		for (i in 0...hexes.length)
		{
			moveHexTo(hexes[i], hexSlots[perm(i)], newCallback);
		}
	}

	public function reset(callback:Callback = null)
	{
		var hexesShuffled:Int = 0;
		var newCallback = () ->
		{
			hexesShuffled++;
			if (hexesShuffled == hexes.length)
			{
				var occupied = hexes.map(hex -> hex.coords);
				unoccupiedHexSlots = hexSlots.filter(slot -> !occupied.contains(slot));
				if (callback != null)
					callback();
			}
		}
		for (i in 0...hexes.length)
		{
			moveHexTo(hexes[i], hexSlots[i], newCallback);
		}
	}

	public function toCartRel(coords:Coords):FlxPoint
	{
		var cart = toCart(coords, Reg.HEX_RADIUS);
		cart.x += x;
		cart.y += y;
		return cart;
	}

	public function getCoords(x:Float, y:Float):Coords
	{
		var comparingTo = FlxPoint.get(x - Reg.HEX_RADIUS, y - Reg.HEX_RADIUS);
		var minDist:Float = null;
		var selection:Coords = null;
		for (coords in hexSlots)
		{
			var dist = comparingTo.distanceTo(toCartRel(coords));
			if (minDist == null || dist < minDist)
			{
				selection = coords;
				minDist = dist;
			}
		}
		comparingTo.put();
		return selection;
	}

	public function isSolved():Bool
	{
		for (hex in hexes)
		{
			if (hex.coords != hexSlots[hex.number - 1])
				return false;
		}
		return true;
	}

	// --------------------

	public static function rotateFacing(facing:Facing, times:Int):Facing
	{
		return Type.createEnumIndex(Facing, (Type.enumIndex(facing) + times).modulo(6));
	}

	public static function facingInt(facing:Facing):Int
	{
		return switch facing
		{
			case NE: 0;
			case E: 1;
			case SE: 2;
			case SW: 3;
			case W: 4;
			case NW: 5;
		}
	}

	public static function facingCoords(facing:Facing):Coords
	{
		return switch facing
		{
			case NE: Coords(1, -1, 0);
			case E: Coords(1, 0, -1);
			case SE: Coords(0, 1, -1);
			case SW: Coords(-1, 1, 0);
			case W: Coords(-1, 0, 1);
			case NW: Coords(0, -1, 1);
		}
	}

	public static function toCart(coords:Coords, size:Float):FlxPoint
	{
		switch coords
		{
			case Coords(q, r, _):
				return FlxPoint.get(size * Math.sqrt(3) * (q + r / 2), size * (3 / 2 * r));
		}
	}

	public static function fromCart(x:Float, y:Float, size:Float):Coords
	{
		var q:Int = Math.round(1 / (size) * (x / Math.sqrt(3) - y / 3));
		var r:Int = Math.round(2 / (3 * size) * y);
		return Coords(q, r, -q - r);
	}

	public static function hexAbs(coords:Coords):Int
	{
		return Math.round((Math.abs(coords.q()) + Math.abs(coords.r()) + Math.abs(coords.s())) / 2);
	}

	public static function hexAdd(coords1:Coords, coords2:Coords):Coords
	{
		return Coords(coords1.q() + coords2.q(), coords1.r() + coords2.r(), coords1.s() + coords2.s());
	}

	public static function hexVector(from:Coords, to:Coords):Coords
	{
		return Coords(to.q() - from.q(), to.r() - from.r(), to.s() - from.s());
	}

	public static function hexDist(from:Coords, to:Coords):Int
	{
		return hexAbs(hexVector(from, to));
	}

	public static function areAdjacent(coords1:Coords, coords2:Coords):Bool
	{
		return hexDist(coords1, coords2) == 1;
	}

	// ----------------

	private function centerXY()
	{
		x = originalX;
		y = originalY;
		locale.x = originalX;
		locale.y = originalY;

		var center:FlxPoint = FlxPoint.get(0, 0);
		for (coords in hexSlots)
		{
			center += locale.getPosition(coords);
		}
		center /= hexSlots.length;
		var diffX = x - center.x;
		var diffY = y - center.y;
		center.put();

		x += diffX;
		y += diffY;
		locale.x += diffX;
		locale.y += diffY;
	}

	private function shadeSlots()
	{
		function missingNeighborFacings(coords:Coords):Array<Facing>
		{
			var missing = [];
			// trace(coords);
			for (facing => direction in directions)
			{
				var otherCoords = hexAdd(coords, direction);
				// trace(otherCoords);
				if (hexSlots.foreach(existingCoords -> !Type.enumEq(existingCoords, otherCoords)))
					missing.push(facing);
			}
			// trace(hexSlots);
			return missing;
		}

		var shadingLocale = new HexPlaneLocale(x, y, Reg.HEX_RADIUS);
		for (coords in hexSlots)
		{
			var hexShade = new HexShade();
			hexShade.setCoords(coords, shadingLocale);
			hexShade.setFrameIndex(missingNeighborFacings(coords));
		}
	}

	private function randomPerm(length:Int):Permutation
	{
		var shuffled = [for (i in 0...length) i];
		FlxG.random.shuffle(shuffled);
		return i -> shuffled[i];
	}

	private function makeEven(perm:Permutation, length:Int):Permutation
	{
		if (isEvenPerm(perm, length))
			return perm;
		return i -> i <= 1 ? perm(1 - i) : perm(i);
	}

	private function isEvenPerm(perm:Permutation, length:Int):Bool
	{
		var result = true;
		for (i in 0...length)
		{
			for (j in i + 1...length)
			{
				result = perm(i) < perm(j) ? result : !result;
			}
		}
		return result;
	}

	private function coordComparison(coords1:Coords, coords2:Coords):Int
	{
		var cart1 = toCart(coords1, 1);
		var cart2 = toCart(coords2, 1);
		if (cart1.y + 0.01 < cart2.y)
		{
			cart1.put();
			cart2.put();
			return -1;
		}
		if (cart1.y > cart2.y + 0.01)
		{
			cart1.put();
			cart2.put();
			return 1;
		}
		if (cart1.x + 0.01 < cart2.x)
		{
			cart1.put();
			cart2.put();
			return -1;
		}
		if (cart1.x > cart2.x + 0.01)
		{
			cart1.put();
			cart2.put();
			return 1;
		}
		cart1.put();
		cart2.put();
		return 0;
	}
}
