package routines;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import gameobjects.*;
import map.*;
import system.*;
import system.Data;

class HandleClickRoutine extends Routine
{
	private var x:Float;
	private var y:Float;
	private var puz:PuzzleRoutine;

	public function new(x:Float, y:Float, puz:PuzzleRoutine)
	{
		super();
		this.x = x;
		this.y = y;
		this.puz = puz;
	}

	override public function hello()
	{
		var coords = puz.hexMap.getCoords(x, y);
		if (puz.budged != null && puz.hexMap.unoccupiedHexSlots.contains(coords))
		{
			var hex = puz.budged;
			var callback = () ->
			{
				puz.budged = null;
				System.misc.hud.incrementMovesMade();
				puz.checkSolved();
				conclude();
			}
			puz.hexMap.moveHexTo(hex, coords, callback);
		}
		else
		{
			var hex = puz.hexMap.hexAt[coords];
			if (hex == null || !puz.hexMap.canBudge(hex))
			{
				conclude();
				return;
			}
			var callback = () ->
			{
				puz.budged = hex;
				puz.lastCoordBudged = hex.coords;
				conclude();
			}
			puz.hexMap.budgeHex(hex, callback);
		}
	}
}
