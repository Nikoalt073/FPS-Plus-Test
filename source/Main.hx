package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.system.System;

class Main extends Sprite
{
	public static var framerate:Int = #if desktop 144 #else 60 #end;
	public static var novid:Bool = false;
	public static var flippymode:Bool = false;

	public function new()
	{
		super();

		#if sys
		novid = Sys.args().contains("-novid");
		flippymode = Sys.args().contains("-flippymode");
		#end

		#if (flixel >= "5.0.0")
		addChild(new FlxGame(1280, 720, Startup, framerate, framerate, true));
		#else
		addChild(new FlxGame(1280, 720, Startup, 1, framerate, framerate, true));
		#end

		addChild(new Overlay(10, 3));

		trace("-=Args=-");
		trace("novid: " + novid);
		trace("flippymode: " + flippymode);
	}
}
