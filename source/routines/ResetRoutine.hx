package routines;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import gameobjects.*;
import map.*;
import system.*;
import system.Data;

class ResetRoutine extends Routine
{
	private var puz:PuzzleRoutine;

	public function new(puz:PuzzleRoutine)
	{
		super();
		this.puz = puz;
	}

	override public function hello()
	{
		puz.hexMap.reset(conclude);
		System.input.setHandler(_ -> {});
	}

	override public function goodbye()
	{
		puz.stopGame();
		puz.resetFlags();
		System.misc.hud.hideTimer();
		System.input.revertHandler();
	}
}
