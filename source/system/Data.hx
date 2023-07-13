package system;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import gameobjects.*;
import map.*;
import routines.*;
import routines.fellow.*;
import routines.player.*;

using Useful;

typedef Callback = Null<() -> Void>;
typedef Permutation = Int->Int;

// ---------------- Enums ------------------

enum InputID
{
	MouseDown(objectID:ObjectID);
	MouseUp(objectID:ObjectID);
	MouseOver(objectID:ObjectID);
	MouseOut(objectID:ObjectID);
	MouseWheel(objectID:ObjectID);
	KeyPressed(key:KeyID);
	KeyReleased(key:KeyID);
	DraggerDropped(objectID:ObjectID);
	EmptyMouseClick;
}

enum Coords
{
	Coords(q:Int, r:Int, s:Int);
}

enum Facing
{
	NE;
	E;
	SE;
	SW;
	W;
	NW;
}

enum KeyID
{
	Backspace;
	Spacebar;
	Up;
	Down;
	Left;
	Right;
}

enum ObjectID
{
	HexID(hex:Hex);
}

enum Tag
{
	HexTag;
}

// ---------------- Interfaces -----------------------

interface IDObject
{
	public var id:ObjectID;
}

interface IDSprite extends IDObject extends IFlxSprite {}

interface Locale<T>
{
	public function remove(t:T, callback:Callback = null):Void;
}

interface Movable
{
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var origin(default, null):FlxPoint;
	public var scale_x(default, set):Float;
	public var scale_y(default, set):Float;
	public var angle(default, set):Float;
	public function moveTo(x:Float, y:Float, callback:Callback = null):Void;
	public function rotate(angleDiff:Float, callback:Callback = null):Void;

	public var inLocale:Null<Locale<Movable>>;
}

class Data
{
	public function new() {}

	public function toSprite(idSprite:IDSprite):FlxSprite
	{
		return Type.enumParameters(idSprite.id)[0];
	}

	public function toTag(idObject:IDObject):Tag
	{
		return idToTag(idObject.id);
	}

	public function idToTag(objectID:ObjectID):Tag
	{
		var idConstructor = Type.enumConstructor(objectID);

		return Type.createEnum(Tag, idConstructor.substr(0, idConstructor.length - 2) + "Tag");
	}
}
