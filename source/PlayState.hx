package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import gameobjects.*;
import map.*;
import routines.*;
import routines.fellow.*;
import routines.player.*;
import system.*;
import system.Data;
import ui.*;

using Useful;

class PlayState extends FlxState
{
	public var fps:FlxText;

	override public function create()
	{
		super.create();

		System.initGlobalSystems();

		System.routine = new PuzzleRoutine();
		System.routine.run();

		initGroups();
	}

	private function initGroups()
	{
		add(new FlxSprite(0, 0, "assets/bg.png"));
		add(Reg.hexShadeGroup);
		add(Reg.hexGroup);
		add(System.misc.hud);
		add(Reg.floatTextGroup);
		FlxG.plugins.get(FlxMouseEventManager).reorder();
	}
}
