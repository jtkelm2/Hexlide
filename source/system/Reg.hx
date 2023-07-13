package system;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gameobjects.*;
import openfl.display.IBitmapDrawable;
import openfl.utils.IAssetCache;
import system.Data;

class Reg
{
	public static var SPACING:Int;

	public static var MAX_MOVE_TIME:Float;

	public static var HEX_RADIUS:Int;
	public static var PLANE_X:Float;
	public static var PLANE_Y:Float;

	public static var HUD_X:Int;
	public static var HUD_WIDTH:Int;
	public static var HUD_HEIGHT:Int;
	public static var BUTTON_WIDTH:Int;
	public static var BUTTON_HEIGHT:Int;
	public static var TIMER_WIDTH:Int;
	public static var MOVECOUNTER_WIDTH:Int;

	public static var SOLVED_COLOR:FlxColor;
	public static var UNSOLVED_COLOR:FlxColor;
	public static var STATS_COLOR:FlxColor;

	// --------- Groups -----------
	public static var hexShadeGroup:FlxTypedGroup<HexShade>;
	public static var hexGroup:FlxTypedGroup<Hex>;
	public static var floatTextGroup:FlxTypedGroup<FlxText>;

	// --------- Levels -----------
	public static var levels:Array<Array<Coords>>;

	public static function initReg()
	{
		SPACING = 10;

		MAX_MOVE_TIME = 0.1;

		HUD_X = 99999;
		HUD_WIDTH = 474;
		HUD_HEIGHT = 85;
		BUTTON_WIDTH = 155;
		BUTTON_HEIGHT = 85;
		TIMER_WIDTH = 320;
		MOVECOUNTER_WIDTH = 150;

		HEX_RADIUS = 50;
		PLANE_X = FlxG.width / 2 - HEX_RADIUS;
		PLANE_Y = FlxG.height / 2 - HEX_RADIUS;

		SOLVED_COLOR = 0xFF507BB2;
		UNSOLVED_COLOR = 0xFF97ABBE;
		STATS_COLOR = 0xFFC3B447;

		hexShadeGroup = new FlxTypedGroup<HexShade>();
		hexGroup = new FlxTypedGroup<Hex>();
		floatTextGroup = new FlxTypedGroup<FlxText>(8);

		levels = [];
		// Mikro
		levels.push([
			Coords(0, -2, 2), Coords(1, -2, 1), Coords(2, -2, 0), Coords(-1, -1, 2), Coords(0, -1, 1), Coords(1, -1, 0), Coords(2, -1, -1), Coords(-1, 0, 1),
			Coords(0, 0, 0), Coords(1, 0, -1)]);
		// Small
		levels.push([
			Coords(-1, -2, 3), Coords(0, -2, 2), Coords(1, -2, 1), Coords(2, -2, 0), Coords(-2, -1, 3), Coords(-1, -1, 2), Coords(0, -1, 1), Coords(1, -1, 0),
			Coords(2, -1, -1), Coords(-2, 0, 2), Coords(-1, 0, 1), Coords(0, 0, 0), Coords(1, 0, -1)]);
		// Classique
		levels.push([
			Coords(0, -3, 3), Coords(1, -3, 2), Coords(2, -3, 1), Coords(-1, -2, 3), Coords(0, -2, 2), Coords(1, -2, 1), Coords(2, -2, 0), Coords(-2, -1, 3),
			Coords(-1, -1, 2), Coords(0, -1, 1), Coords(1, -1, 0), Coords(2, -1, -1), Coords(-2, 0, 2), Coords(-1, 0, 1), Coords(0, 0, 0), Coords(1, 0, -1),
			Coords(-2, 1, 1), Coords(-1, 1, 0), Coords(0, 1, -1)]);
		// Gigante
		levels.push([
			Coords(1, -2, 1), Coords(2, -2, 0), Coords(2, -1, -1), Coords(2, 0, -2), Coords(1, 1, -2), Coords(0, 2, -2), Coords(-1, 2, -1), Coords(-2, 2, 0),
			Coords(-2, 1, 1), Coords(-2, 0, 2), Coords(-1, -1, 2), Coords(0, -2, 2), Coords(0, -3, 3), Coords(1, -3, 2), Coords(2, -3, 1), Coords(3, -3, 0),
			Coords(3, -2, -1), Coords(3, -1, -2), Coords(3, 0, -3), Coords(2, 1, -3), Coords(1, 2, -3), Coords(0, 3, -3), Coords(-1, 3, -2),
			Coords(-2, 3, -1), Coords(-3, 3, 0), Coords(-3, 2, 1), Coords(-3, 1, 2), Coords(-3, 0, 3), Coords(-2, -1, 3), Coords(-1, -2, 3), Coords(-1, 1, 0),
			Coords(-1, 0, 1), Coords(0, -1, 1), Coords(1, -1, 0), Coords(1, 0, -1), Coords(0, 1, -1)]);
	}
}
