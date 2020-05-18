package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxSave;

class EndState extends FlxState
{
	var win_text:FlxText;
	var next_btn:FlxButton;
	var index_level:Int;
	var save_data:FlxSave;

	override public function new(index_level:Int)
	{
		super();
		this.index_level = index_level;
		save_data = new FlxSave();
		save_data.bind("save_lvl");
		save_data.data.lvl = this.index_level;
		save_data.flush();
	}

	override function create()
	{
		super.create();
		if (index_level == Levels.LEVELS.length)
		{
			win_text = new FlxText(0, 0, 0, "You are winner!!!!");
			win_text.screenCenter();
			add(win_text);
		}
		else
		{
			next_btn = new FlxButton(0, 0, "next level", next_lvl);
			next_btn.screenCenter();
			add(next_btn);
		}
	}

	function next_lvl()
	{
		FlxG.switchState(new PlayState(this.index_level));
	}
}
