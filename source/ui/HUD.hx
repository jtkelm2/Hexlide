package ui;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxVerticalAlign;
import gameobjects.*;
import map.*;
import routines.*;
import routines.ShuffleRoutine;
import system.*;
import system.Data;

class HUD extends FlxGroup
{
	public var hudCamera:FlxCamera;

	private var levelButtons:Array<FlxButton>;

	private var timerActive:Bool;
	private var timerFrozen:Bool;
	private var timeTaken:Float;
	private var movesMade:Int;

	private var timerText:FlxText;
	private var movesMadeText:FlxText;

	public function new(puz:PuzzleRoutine)
	{
		super();

		hudCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		hudCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(hudCamera, false);
		hudCamera.scroll.x += Reg.HUD_X;
		camera = hudCamera;

		timerActive = false;
		timerFrozen = false;
		timeTaken = 0;
		movesMade = 0;

		initHudSprites(puz);
	}

	private function initHudSprites(puz:PuzzleRoutine)
	{
		var spriteGroup = new FlxTypedGroup<FlxSprite>(9);
		add(spriteGroup);

		var hudBack = new FlxSprite();
		hudBack.loadGraphic("assets/hudBack.png");
		hudBack.screenCenter(X);
		hudBack.y = FlxG.height - Reg.HUD_HEIGHT;
		spriteGroup.add(hudBack);

		spriteGroup.add(makeButton((hudBack.x - Reg.BUTTON_WIDTH) / 2, FlxG.height - Reg.BUTTON_HEIGHT, () -> System.routine.queue(new ShuffleRoutine(puz)),
			"Shuffle", 42, Reg.UNSOLVED_COLOR));
		// var shuffleButton = new FlxButton();
		// shuffleButton.label.offset.set(-10, -16);
		spriteGroup.add(makeButton((hudBack.x - Reg.BUTTON_WIDTH) / 2 + hudBack.x + hudBack.width, FlxG.height - Reg.BUTTON_HEIGHT,
			() -> System.routine.queue(new ResetRoutine(puz)), "Reset", 42, Reg.SOLVED_COLOR));

		var levelNames = ["Mikro", "Small", "Classique", "Gigante"];
		levelButtons = [];
		for (level in 0...4)
		{
			var button = makeButton(FlxG.width / 2 + (level - 2) * (Reg.BUTTON_WIDTH + 10), 0, () ->
			{
				lightButton(level);
				puz.loadLevel(Reg.levels[level]);
			}, levelNames[level], 36, Reg.SOLVED_COLOR);
			levelButtons.push(button);
			spriteGroup.add(button);
		}
		lightButton(2);

		timerText = new FlxText();
		timerText.size = 36;
		timerText.x = hudBack.x;
		timerText.y = FlxG.height - Reg.HUD_HEIGHT + (Reg.HUD_HEIGHT - timerText.height) / 2;
		timerText.color = Reg.STATS_COLOR;
		timerText.fieldWidth = Reg.TIMER_WIDTH;
		timerText.alignment = CENTER;
		timerText.visible = false;
		spriteGroup.add(timerText);

		movesMadeText = new FlxText();
		movesMadeText.size = 36;
		movesMadeText.x = timerText.x + Reg.TIMER_WIDTH;
		movesMadeText.y = FlxG.height - Reg.HUD_HEIGHT + (Reg.HUD_HEIGHT - movesMadeText.height) / 2;
		movesMadeText.color = Reg.STATS_COLOR;
		movesMadeText.fieldWidth = Reg.HUD_WIDTH - Reg.TIMER_WIDTH;
		movesMadeText.alignment = CENTER;
		movesMadeText.visible = false;
		spriteGroup.add(movesMadeText);

		for (member in spriteGroup.members)
		{
			member.x += Reg.HUD_X;
			member.camera = hudCamera;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (timerActive)
		{
			timeTaken += elapsed;
			updateStats();
		}
		else
		{
			if (!timerFrozen)
			{
				hideStats();
			}
		}
	}

	public function startTimer()
	{
		timeTaken = 0;
		movesMade = 0;
		showStats();
		timerActive = true;
		timerFrozen = false;
		System.effects.toggleTransparing(timerText, false);
		System.effects.toggleTransparing(movesMadeText, false);
	}

	public function hideTimer()
	{
		timerActive = false;
		timerFrozen = false;
	}

	public function startVictory()
	{
		timerActive = false;
		timerFrozen = true;
		System.effects.toggleTransparing(timerText, true);
		System.effects.toggleTransparing(movesMadeText, true);
	}

	public function stopVictory()
	{
		System.effects.toggleTransparing(timerText, false);
		System.effects.toggleTransparing(movesMadeText, false);
	}

	public function incrementMovesMade()
	{
		movesMade++;
	}

	// ---------------------------

	private function updateStats()
	{
		var minutes = Math.floor(timeTaken / 60);
		var seconds = Math.round(timeTaken - 60 * minutes);
		timerText.text = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
		// timerText.x = (FlxG.width - Reg.HUD_WIDTH) / 2 + Reg.TIMER_WIDTH - timerText.width + Reg.HUD_X;

		movesMadeText.text = Std.string(movesMade);
		// movesMadeText.x = (FlxG.width + Reg.HUD_WIDTH) / 2 - movesMadeText.width - 8 + Reg.HUD_X;
	}

	private function showStats()
	{
		timerText.visible = true;
		movesMadeText.visible = true;
	}

	private function hideStats()
	{
		timerText.visible = false;
		movesMadeText.visible = false;
	}

	private function makeButton(x:Float, y:Float, onDown:Callback, label:String, size:Int, color:FlxColor):FlxButton
	{
		var button = new FlxButton();
		button.loadGraphic("assets/button.png", true, 155, 85);
		button.scrollFactor.set(1, 1);
		button.x = x;
		button.y = y;
		button.label = new FlxText(0, 0, button.width, label, size);
		button.label.font = "assets/BebasNeue-Regular.ttf";
		button.label.alignment = CENTER;
		button.label.color = color;
		button.label.offset.set(0, -(button.height - button.label.height) / 2);
		button.onDown.callback = onDown;
		return button;
	}

	private function lightButton(toLight:Int)
	{
		for (i in 0...levelButtons.length)
		{
			var button = levelButtons[i];
			if (i == toLight)
			{
				button.label.color = Reg.UNSOLVED_COLOR;
			}
			else
			{
				button.label.color = Reg.SOLVED_COLOR;
			}
		}
	}
}
