package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import system.Data;

class Useful
{
	public static function q(coords:Coords):Int
	{
		switch coords
		{
			case Coords(q, _, _):
				return q;
		}
	}

	public static function r(coords:Coords):Int
	{
		switch coords
		{
			case Coords(_, r, _):
				return r;
		}
	}

	public static function s(coords:Coords):Int
	{
		switch coords
		{
			case Coords(_, _, s):
				return s;
		}
	}
}

function oppositeDirection(key:KeyID):Null<KeyID>
{
	return switch key
	{
		case Left:
			Right;
		case Right:
			Left;
		case Up:
			Down;
		case Down:
			Up;
		case _:
			null;
	}
}

function modulo(n:Int, d:Int):Int
{
	var r = n % d;
	if (r < 0)
		r += d;
	return r;
}

function chooseMaxes<T>(arr:Array<T>, discriminator:T->Int):Array<T>
{
	if (arr.length == 0)
	{
		return [];
	}

	var results = [arr[0]];
	var maxVal = discriminator(arr[0]);
	for (i in 1...arr.length)
	{
		var x = arr[i];
		var val = discriminator(x);
		if (val >= maxVal)
		{
			if (val > maxVal)
			{
				results = [x];
				maxVal = val;
			}
			else
			{
				results.push(x);
			}
		}
	}
	return results;
}

function last<T>(arr:Array<T>):T
{
	return arr[arr.length - 1];
}
