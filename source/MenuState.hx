package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxSave;

class MenuState extends FlxState
{
	var btn_play:FlxButton;
	var btn_continue:FlxButton;
	var save_data:FlxSave;

	override function create()
	{
		super.create();
		save_data = new FlxSave();
		save_data.bind("save_lvl");
		FlxG.log.notice(save_data.data.lvl);
		btn_play = new FlxButton(0, FlxG.height / 2, "New game", start_play);
		btn_play.screenCenter(FlxAxes.X);
		btn_continue = new FlxButton(0, FlxG.height / 2 + 30, "Continue", continue_game);
		btn_continue.screenCenter(FlxAxes.X);
		if (save_data.data.lvl != null)
		{
			btn_continue.alpha = 1;
		}
		else
		{
			btn_continue.alpha = 0.5;
		}
		add(btn_continue);
		add(btn_play);
	}

	function start_play()
	{
		FlxG.switchState(new PlayState());
	}

	function continue_game()
	{
		if (save_data.data.lvl != null)
		{
			FlxG.switchState(new PlayState(save_data.data.lvl));
		}
	}
}
