package;

import Player.Move_direction;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;

class Box extends FlxSprite
{
	public var is_docked:Bool = false;
	public var on_movement:Bool = false;

	var last_pos:FlxPoint;
	var speed:Int = 4;
	var move_direction:Move_direction;
	var move_sound:FlxSound;

	override public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.box__png, true, 32, 32);
		move_sound = FlxG.sound.load(AssetPaths.block_move__wav);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (on_movement)
		{
			move_sound.play(true);
			switch (move_direction)
			{
				case UP:
					y -= speed;
				case DOWN:
					y += speed;
				case LEFT:
					x -= speed;
				case RIGHT:
					x += speed;
			}
		}
		if ((x % Player.TILE_SIZE == 0) && (y % Player.TILE_SIZE == 0))
		{
			on_movement = false;
		}
		if (is_docked)
		{
			animation.frameIndex = 1;
		}
		else
		{
			animation.frameIndex = 0;
		}
	}

	public function can_move(direction:Move_direction, tilemap:FlxTilemap, boxes:FlxTypedGroup<Box> = null):Bool
	{
		var futur_pos:FlxPoint = new FlxPoint();
		var offset_pos:FlxPoint;
		switch (direction)
		{
			case UP:
				futur_pos.x = x + (Player.TILE_SIZE / 2);
				futur_pos.y = y + (Player.TILE_SIZE / 2) - (Player.TILE_SIZE * 2);
				offset_pos = new FlxPoint(0, -Player.TILE_SIZE);
			case DOWN:
				futur_pos.x = x + (Player.TILE_SIZE / 2);
				futur_pos.y = y + (Player.TILE_SIZE / 2) + (Player.TILE_SIZE * 2);
				offset_pos = new FlxPoint(0, Player.TILE_SIZE);
			case LEFT:
				futur_pos.x = x + (Player.TILE_SIZE / 2) - (Player.TILE_SIZE * 2);
				futur_pos.y = y + (Player.TILE_SIZE / 2);
				offset_pos = new FlxPoint(-Player.TILE_SIZE, 0);
			case RIGHT:
				futur_pos.x = x + (Player.TILE_SIZE / 2) + (Player.TILE_SIZE * 2);
				futur_pos.y = y + (Player.TILE_SIZE / 2);
				offset_pos = new FlxPoint(Player.TILE_SIZE, 0);
		}
		if (!tilemap.ray(this.getMidpoint(), futur_pos))
		{
			return false;
		}
		if (boxes != null)
		{
			for (box in boxes)
			{
				if (move_to_box(box, offset_pos, futur_pos))
				{
					return false;
				}
			}
		}
		return true;
	}

	function move_to_box(box:Box, offset_pos:FlxPoint, futur_pos:FlxPoint):Bool
	{
		var off_mid_point:FlxPoint = box.getMidpoint();
		off_mid_point.x += offset_pos.x;
		off_mid_point.y += offset_pos.y;
		if ((off_mid_point.x == futur_pos.x) && (off_mid_point.y == futur_pos.y))
		{
			return true;
		}
		return false;
	}

	public function move_to(direction:Move_direction)
	{
		if (!on_movement)
		{
			last_pos = getPosition();
			move_direction = direction;
			on_movement = true;
		}
	}
}
