package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class LoadingScreenState extends MusicBeatState
{
    var progress:Float;
    var nextScene:String;
    var loadingTime:Float;
    var timeElapsed:Float;
    var loadingBar:FlxSprite;

    public function new()
    {
        super();
        progress = 0.0;
        loadingTime = 10;
        timeElapsed = 0;
        nextScene = "MainScene";
        loadingBar = new FlxSprite('timeBar');
        loadingBar.makeGraphic(100, 20, 0x00FFA500);
        add(loadingBar);
        // Start loading the next scene
        FlxG.loadLibrary(nextScene, onComplete);
    }

    private function onComplete():Void{
        // Update the loading bar or animation
        progress = FlxG.library.getProgress();
        // Once the next scene is fully loaded, switch to it
        if(progress == 1.0){
            MusicBeatState.switchState(new TitleState());
        }
    }

    override public function update():Void{
        super.update();
        timeElapsed += FlxG.elapsed;
        if (timeElapsed >= loadingTime)
        {
            MusicBeatState.switchState(new TitleState());
        }
    }
}
