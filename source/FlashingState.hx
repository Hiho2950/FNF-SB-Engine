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

class FlashingState extends MusicBeatState
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
			"Hey, Watch Out!\n
			Be Careful When You Touch The Phone Fast!\n
			You Can Break Your Phone Screen If you Do That.\n
			This Mod Contains Some Flashing Lights!\n
			Press A To Disable Them Now Or Go To Options Menu.\n
			Press B To Ignore This Message.\n
			You've Been Warned!",
			32);
		#else
		warnText = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			This Mod Contains Some Flashing Lights!\n
			Press ENTER To Disable Them Now Or Go To Options Menu.\n
			Press ESCAPE To Ignore This Message.\n
			You've Been Warned!",
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
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						#if android
						virtualPad.alpha = 0;
						#end
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					#if android
					FlxTween.tween(virtualPad, {alpha: 0}, 1);
					#end
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
