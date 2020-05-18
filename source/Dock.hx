package;

import flixel.FlxSprite;

class Dock extends FlxSprite
{
	override public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.yoshi_32_dock__png);
	}
}
