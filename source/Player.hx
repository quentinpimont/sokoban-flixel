package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

enum Move_direction
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

class Player extends FlxSprite
{
	public static inline var TILE_SIZE:Int = 32;

	public var on_movement:Bool = false;
	public var move_direction:Move_direction;
	public var last_pos:FlxPoint;
	public var nb_movement:Int = 0;

	var speed = 2;
	var step_sound:FlxSound;

	override public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.player__png, true, 32, 32);
		animation.add("u", [2, 3], 6, false);
		animation.add("d", [0, 1], 6, false);
		animation.add("l", [4, 5], 6, false);
		animation.add("r", [6, 7], 6, false);
		step_sound = FlxG.sound.load(AssetPaths.walk__wav);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (on_movement)
		{
			step_sound.play();
			switch (move_direction)
			{
				case UP:
					y -= speed;
					animation.play("u");
				case DOWN:
					y += speed;
					animation.play("d");
				case LEFT:
					x -= speed;
					animation.play("l");
				case RIGHT:
					x += speed;
					animation.play("r");
			}
		}
		if ((x % TILE_SIZE == 0) && (y % TILE_SIZE == 0))
		{
			if (on_movement)
			{
				nb_movement++;
			}
			on_movement = false;
		}

		if (FlxG.keys.anyPressed([DOWN]))
		{
			move_to(Move_direction.DOWN);
		}
		else if (FlxG.keys.anyPressed([UP]))
		{
			move_to(Move_direction.UP);
		}
		else if (FlxG.keys.anyPressed([LEFT]))
		{
			move_to(Move_direction.LEFT);
		}
		else if (FlxG.keys.anyPressed([RIGHT]))
		{
			move_to(Move_direction.RIGHT);
		}
	}

	function move_to(direction:Move_direction)
	{
		if (!on_movement)
		{
			last_pos = getPosition();
			move_direction = direction;
			on_movement = true;
		}
	}
}
