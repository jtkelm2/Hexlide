package system;

import ai.*;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import gadgets.*;
import gameobjects.*;
import map.*;
import routines.*;
import routines.*;
import routines.fellow.*;
import routines.fellow.*;
import routines.player.*;
import routines.player.*;
import system.*;
import system.Data;
import system.Input;
import ui.*;

class System
{
	public static var effects:Effects;
	public static var input:Input;
	public static var mouse:Mouse;
	public static var keys:Keys;
	public static var data:Data;
	public static var signals:Signals;

	public static var misc:Misc;

	public static var routine:Routine;

	public static function initGlobalSystems()
	{
		Reg.initReg();

		FlxG.camera.bgColor = 0xFF595959;

		signals = new Signals();
		data = new Data();
		effects = new Effects();
		input = new Input();
		mouse = input.mouse;
		keys = input.keys;

		misc = new Misc();
	}

	public static function refreshStateSystems()
	{
		input.refreshState();
		mouse = input.mouse;
		keys = input.keys;
	}

	public static function initMovable(movable:Movable)
	{
		movable.scale_x = 1;
		movable.scale_y = 1;
		movable.angle = 0;
	}
}

class Signals
{
	public var newInput:FlxTypedSignal<InputID->Void>;

	public function new()
	{
		newInput = new FlxTypedSignal<InputID->Void>();
	}
}

class Misc
{
	public var hud:HUD;

	public function new() {}
}
