package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'discord',
		'options'
	];

	var sidebar:FlxSprite;
	var options:FlxSprite;
	var freeplay:FlxSprite;
	var bg:FlxSprite;
	var discord:FlxSprite;
	var credits:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var hoverSelected:Int;

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Menus", null);
		#end

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.01 - (0.35 * (optionShit.length + 20)), 0.05);
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.175*scaleRatio ));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.color = 0xFFd9d9d9;
		add(bg);

		discord = new FlxSprite().loadGraphic(Paths.image('discord'));
		discord.scrollFactor.x = 0;
		discord.scrollFactor.y = 0;
		discord.setGraphicSize(Std.int(discord.width * 1.175*scaleRatio ));
		discord.updateHitbox();
		discord.screenCenter();
		discord.antialiasing = ClientPrefs.globalAntialiasing;
		discord.color = 0xFFd9d9d9;

		options = new FlxSprite().loadGraphic(Paths.image('options'));
		options.scrollFactor.x = 0;
		options.scrollFactor.y = 0;
		options.setGraphicSize(Std.int(options.width * 1.175*scaleRatio ));
		options.updateHitbox();
		options.screenCenter();
		options.antialiasing = ClientPrefs.globalAntialiasing;
		options.color = 0xFFd9d9d9;

		freeplay = new FlxSprite().loadGraphic(Paths.image('freeplay'));
		freeplay.scrollFactor.x = 0;
		freeplay.scrollFactor.y = 0;
		freeplay.setGraphicSize(Std.int(freeplay.width * 1.175*scaleRatio ));
		freeplay.updateHitbox();
		freeplay.screenCenter();
		freeplay.antialiasing = ClientPrefs.globalAntialiasing;
		freeplay.color = 0xFFd9d9d9;

		credits = new FlxSprite().loadGraphic(Paths.image('credits'));
		credits.scrollFactor.x = 0;
		credits.scrollFactor.y = 0;
		credits.setGraphicSize(Std.int(credits.width * 1.175*scaleRatio ));
		credits.updateHitbox();
		credits.screenCenter();
		credits.antialiasing = ClientPrefs.globalAntialiasing;
		credits.color = 0xFFd9d9d9;

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175*scaleRatio ));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);

		sidebar = new FlxSprite(-80).loadGraphic('assets/images/sideBar.png');
		sidebar.scrollFactor.x = 0;
		sidebar.scrollFactor.y = 0;
		sidebar.setGraphicSize(Std.int(sidebar.width * 1));
		sidebar.updateHitbox();
		sidebar.screenCenter();
		sidebar.x -= 300;
		sidebar.antialiasing = true;
		FlxTween.tween(sidebar, {x: sidebar.x + 200}, 1, {ease: FlxEase.expoInOut});
		add(sidebar);

		var logoBLScale:Float = 0.3;

		var logoBl:FlxSprite = new FlxSprite();
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.scale.x = logoBLScale;
		logoBl.scale.y = logoBLScale;
		logoBl.scrollFactor.x = 0;
		logoBl.scrollFactor.y = 0;
		logoBl.x = 650;
		logoBl.y = -250;
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		add(logoBl);

		/*var scythe:FlxSprite = new FlxSprite().loadGraphic(Paths.image('assets/images/Scythe.png'));
		scythe.scrollFactor.x = 0;
		scythe.scrollFactor.y = 0;
		scythe.x = 500;
		scythe.y = -250;
		scythe.updateHitbox();
		scythe.antialiasing = ClientPrefs.globalAntialiasing;
		add(scythe);*/

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.5;

		for (i in 0...optionShit.length)
		{
			var offset:Float = 350 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 100)  + offset);

			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();

			switch (i)
			{
				case 0:
					menuItem.x += 730;
				case 1:
					menuItem.x += 820;
				case 2:
					menuItem.x += 950;
				case 3:
					menuItem.y -= 140;
					menuItem.x += 780;
					menuItem.scale.set(0.12, 0.12);
				case 4:
					menuItem.x += 600;
					menuItem.y -= 25;
			}

		}

		FlxG.camera.follow(camFollowPos, null, 1);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'discord')
				{
					CoolUtil.browserLoad('https://discord.gg/3KYAWSqjY3');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxTween.tween(sidebar, {x: sidebar.x - 2000}, 1, {ease: FlxEase.expoInOut});
					FlxTween.tween(bg, {x: bg.x - 2000}, 1, {ease: FlxEase.expoInOut});
					FlxTween.tween(freeplay, {x: freeplay.x - 2000}, 1, {ease: FlxEase.expoInOut});
					FlxTween.tween(credits, {x: credits.x - 2000}, 1, {ease: FlxEase.expoInOut});
					FlxTween.tween(options, {x: options.x - 2000}, 1, {ease: FlxEase.expoInOut});

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);
					FlxTween.tween(FlxG.camera, {zoom: 5}, 2, {ease: FlxEase.expoIn});

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

	//	menuItems.forEach(function(spr:FlxSprite)
	//	{
	//		spr.x = 800;
	//	});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		switch (curSelected)
		{
		case 0:
			remove(credits);
			remove(discord);
			remove(options);
			remove(freeplay);
			add(bg);
			add(sidebar);
		case 1:	
			remove(credits);
			remove(bg);
			remove(options);
			remove(discord);
			add(freeplay);
			add(sidebar);
		case 2:
			remove(options);
			remove(freeplay);
			remove(bg);
			remove(discord);
			add(credits);
			add(sidebar);
		case 3:
			remove(credits);
			remove(options);
			remove(freeplay);
			remove(bg);
			add(discord);
			add(sidebar);
		case 4:
			remove(credits);
			remove(freeplay);
			remove(bg);
			remove(discord);
			add(options);
			add(sidebar);
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}

				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
