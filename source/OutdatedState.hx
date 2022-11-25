package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		#if android
		warnText = new FlxText(0, 0, FlxG.width,
			"Hello Player, Looks Like You're Running An   \n
			Outdated Version Of SB Engine With Android Support (" + MainMenuState.sbEngineVersion + ").\n
			Please Update To " + TitleState.updateVersion + "!\n
			Press B To Proceed Anyway.\n
			\n
			Thank You For Using The Port Of The SB Engine!",
			32);
		#else
		warnText = new FlxText(0, 0, FlxG.width,
			"Hello Player, Looks Like You're Running An   \n
			Outdated Version Of SB Engine (" + MainMenuState.sbEngineVersion + ").\n
			Please Update To " + TitleState.updateVersion + "!\n
			Press ESCAPE To Proceed Anyway.\n
			\n
			Thank You For Using The Engine!",
			32);
		#end
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

		#if android
		addVirtualPad(NONE, A_B);
		#end
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/StefanBETA2008/FNF-SB-Engine");
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
