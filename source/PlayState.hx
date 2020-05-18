package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var boxes:FlxTypedGroup<Box>;
	var docks:FlxTypedGroup<Dock>;
	var is_win:Int = 0;
	var index_level:Int;
	var map_lvl:String;
	var HUD:HUD;
	var docked_sound:FlxSound;

	override public function new(index_level:Int = 0)
	{
		super();
		this.index_level = index_level;
		map_lvl = Levels.LEVELS[this.index_level];
	}

	override public function create()
	{
		map = new FlxOgmo3Loader(AssetPaths.sokoban__ogmo, map_lvl);
		walls = map.loadTilemap(AssetPaths.tileset__png, "walls");
		walls.follow();
		walls.setTileProperties(1, FlxObject.ANY);
		walls.setTileProperties(2, FlxObject.NONE);
		add(walls);
		HUD = new HUD();
		HUD.update_lvl(index_level + 1);
		add(HUD);
		docks = new FlxTypedGroup<Dock>();
		add(docks);
		boxes = new FlxTypedGroup<Box>();
		add(boxes);
		player = new Player();
		add(player);
		map.loadEntities(load_entities, "entities");
		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(AssetPaths.main_theme__wav);
		}
		super.update(elapsed);
		HUD.update_movement(player.nb_movement);
		if (FlxG.collide(player, walls))
		{
			player.on_movement = false;
		}
		FlxG.overlap(player, boxes, collide_player_box);
		boxes.forEach(reset_box);
		FlxG.overlap(boxes, docks, collide_box_dock);
		is_win = 0;
		boxes.forEach(check_win);
		if (is_win == boxes.length && !player.on_movement)
		{
			FlxG.switchState(new EndState(index_level + 1));
		}
		reset_lvl();
	}

	function reset_lvl()
	{
		if (FlxG.keys.anyJustPressed([R]))
		{
			FlxG.switchState(new PlayState(this.index_level));
		}
	}

	function check_win(box:Box)
	{
		if (box.is_docked)
		{
			is_win++;
		}
	}

	function reset_box(box:Box)
	{
		box.is_docked = false;
	}

	function collide_box_dock(box:Box, dock:Dock)
	{
		if (!box.on_movement)
		{
			box.is_docked = true;
		}
	}

	function collide_player_box(c_player:Player, box:Box)
	{
		if (box.can_move(c_player.move_direction, walls, boxes))
		{
			box.move_to(c_player.move_direction);
		}
		else
		{
			c_player.setPosition(c_player.last_pos.x, c_player.last_pos.y);
			c_player.on_movement = false;
		}
	}

	function load_entities(entity:EntityData)
	{
		var x:Float = entity.x;
		var y:Float = entity.y;
		switch (entity.name)
		{
			case "player":
				player.setPosition(x, y);
			case "docks":
				docks.add(new Dock(x, y));
			case "box":
				boxes.add(new Box(x, y));
		}
	}
}
