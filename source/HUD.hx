package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var backroung:FlxSprite;
	var lvl_nb:FlxText;
	var movement:FlxText;

	override public function new()
	{
		super();
		backroung = new FlxSprite().makeGraphic(FlxG.width, 32, FlxColor.BLACK);
		backroung.drawRect(0, 31, FlxG.width, 1, FlxColor.WHITE);
		lvl_nb = new FlxText(200, 8, 0, "Level : 1", 8);
		lvl_nb.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		movement = new FlxText(0, 8, 0, "Movement : 0", 8);
		movement.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		movement.alignment = LEFT;
		lvl_nb.alignment = RIGHT;
		add(backroung);
		add(movement);
		add(lvl_nb);
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	public function update_movement(movement:Int)
	{
		this.movement.text = "Movement : " + movement;
	}

	public function update_lvl(lvl:Int)
	{
		this.lvl_nb.text = "Level : " + lvl;
	}
}
