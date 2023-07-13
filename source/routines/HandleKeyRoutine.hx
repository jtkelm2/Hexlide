package routines;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import gameobjects.*;
import map.*;
import system.*;
import system.Data;

using Useful;

class HandleKeyRoutine extends Routine
{
	private var direction:KeyID;
	private var puz:PuzzleRoutine;

	public function new(direction:KeyID, puz:PuzzleRoutine)
	{
		super();
		this.direction = direction;
		this.puz = puz;
	}

	override public function hello()
	{
		resolveKeyPress(direction);
		conclude();
	}

	private function resolveKeyPress(direction:KeyID)
	{
		function selectAmong(coordsList:Array<Coords>, ?bias:Coords, ?biasFor:Bool):Null<Coords>
		{
			var discriminator:Coords->Int = switch direction
			{
				case Up:
					coords -> -coords.r();
				case Down:
					coords -> coords.r();
				case Right:
					coords -> 2 * coords.q() + coords.r();
				case _:
					coords -> -2 * coords.q() - coords.r();
			}
			var signedDiscriminator = puz.budged != null ? discriminator : coords -> -discriminator(coords);
			var results = coordsList.chooseMaxes(signedDiscriminator);
			if (bias != null)
			{
				if (biasFor && results.contains(bias))
				{
					return bias;
				}
				if (!biasFor && results.length > 1)
				{
					results.remove(bias);
				}
			}
			return results.length == 1 ? results[0] : null;
		}

		if (puz.budged != null)
		{
			var biasFor = direction.oppositeDirection() == puz.lastKeyPressed;
			var selected = selectAmong(puz.hexMap.unoccupiedHexSlots, puz.lastCoordBudged, biasFor);
			if (puz.resolveCoordsClick(selected, this))
				puz.lastKeyPressed = direction;
		}
		else
		{
			var coordsOptions = puz.hexMap.hexes.filter(puz.hexMap.canBudge).map(hex -> hex.coords);
			if (puz.resolveCoordsClick(selectAmong(coordsOptions), this))
				puz.lastKeyPressed = direction;
		}
	}
}
