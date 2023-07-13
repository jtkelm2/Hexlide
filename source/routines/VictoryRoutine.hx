package routines;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameobjects.*;
import map.*;
import system.*;
import system.Data;
import ui.*;

using Useful;

class VictoryRoutine extends Routine
{
	private var puz:PuzzleRoutine;

	private var waitTime:Float;
	private var tintNumber:Int;

	public function new(puz:PuzzleRoutine)
	{
		super();
		this.puz = puz;
	}

	override public function hello()
	{
		waitTime = 0.3;
		tintNumber = 0;
		puz.stopGame();
		System.misc.hud.startVictory();
		System.input.setHandler(handler);
	}

	override public function goodbye()
	{
		System.misc.hud.stopVictory();
		for (hex in puz.hexMap.hexes)
		{
			hex.toggleTint(hex.coords == puz.hexMap.hexSlots[hex.number - 1]);
		}
		System.input.revertHandler();
	}

	override public function idle(elapsed:Float)
	{
		waitTime -= elapsed;
		if (waitTime < 0)
		{
			waitTime += 0.3;
			tintNumber++;
			for (hex in puz.hexMap.hexes)
			{
				hex.toggleTint((hex.coords.s() - tintNumber) % 4 == 0);
			}
		}
	}

	private function handler(inputID:InputID)
	{
		switch inputID
		{
			case KeyPressed(_) | MouseDown(_) | EmptyMouseClick:
				conclude();
			case _:
		}
	}
}
