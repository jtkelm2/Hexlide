package routines;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import gameobjects.*;
import map.*;
import system.*;
import system.Data;

class ShuffleRoutine extends Routine
{
	private var puz:PuzzleRoutine;

	public function new(puz:PuzzleRoutine)
	{
		super();
		this.puz = puz;
	}

	override public function hello()
	{
		puz.hexMap.instantShuffle(conclude);
		System.input.setHandler(_ -> {});
	}

	override public function goodbye()
	{
		puz.startGame();
		puz.resetFlags();
		System.misc.hud.startTimer();
		System.input.revertHandler();
	}
}
