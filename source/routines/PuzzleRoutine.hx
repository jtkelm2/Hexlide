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

class PuzzleRoutine extends Routine
{
	public var hexMap:HexMap;
	public var budged:Null<Hex>;
	public var lastCoordBudged:Null<Coords>;
	public var lastKeyPressed:KeyID;

	private var fps:FlxText;
	private var gameInProgress:Bool;

	public function new()
	{
		super();
	}

	override public function hello()
	{
		System.input.setHandler(handler);
		var hexSlots = Reg.levels[2];
		hexMap = new HexMap(Reg.PLANE_X, Reg.PLANE_Y, hexSlots);

		gameInProgress = false;

		System.misc.hud = new HUD(this);

		fps = new FlxText();
		fps.camera = System.misc.hud.hudCamera;
		fps.x = Reg.HUD_X;
		fps.y = 0;
		fps.size = 32;
		fps.color = FlxColor.BLACK;
		FlxG.state.add(fps);
	}

	private function handler(inputID:InputID)
	{
		switch inputID
		{
			case KeyPressed(Spacebar):
				if (budged == null && idling())
				{
					queue(new ShuffleRoutine(this));
				}
			case KeyPressed(Backspace):
				if (budged == null && idling())
				{
					queue(new ResetRoutine(this));
				}
			case KeyPressed(direction):
				if (subroutines.length <= 3)
					queue(new HandleKeyRoutine(direction, this));
			case MouseDown(_) | EmptyMouseClick:
				queue(new HandleClickRoutine(FlxG.mouse.x, FlxG.mouse.y, this));
			case _:
		}
	}

	override public function idle(_)
	{
		// fps.text = '${hexMap.getCoords(FlxG.mouse.x, FlxG.mouse.y)}';
	}

	public function startGame()
	{
		gameInProgress = true;
	}

	public function stopGame()
	{
		gameInProgress = false;
	}

	public function resetFlags()
	{
		budged = null;
		lastCoordBudged = null;
		lastKeyPressed = null;
	}

	public function loadLevel(hexSlots:Array<Coords>)
	{
		resetFlags();
		stopGame();
		System.misc.hud.hideTimer();
		hexMap.loadLevel(hexSlots);
	}

	public function checkSolved()
	{
		if (gameInProgress && budged == null && hexMap.isSolved())
		{
			interrupt();
			queue(new VictoryRoutine(this));
		}
	}

	public function resolveCoordsClick(coords:Coords, ?routine:Routine):Bool
	{
		if (coords != null)
		{
			var routine = routine == null ? this : routine;
			var point = hexMap.toCartRel(coords);
			routine.queue(new HandleClickRoutine(point.x + Reg.HEX_RADIUS, point.y + Reg.HEX_RADIUS, this));
			point.put();
			return true;
		}
		return false;
	}
}
