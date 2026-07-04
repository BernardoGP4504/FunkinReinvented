import flixel.math.FlxMath;
import funkin.audio.FunkinSound;
import funkin.Conductor;
import funkin.graphics.shaders.RuntimeRainShader;
import funkin.play.song.Song;
import openfl.filters.ShaderFilter;

class BlammedReinventedShader extends Song
{
	var rainShader:RuntimeRainShader = new RuntimeRainShader();
  var rainShaderFilter:ShaderFilter;
	// as song goes on, these are used to make the rain more intense throught the song
  // these values are also used for the rain sound effect volume intensity!
  var rainShaderStartIntensity:Float = 0.3;
  var rainShaderEndIntensity:Float = 0.1;

	function new() { super('blammed-reinvented'); }

	override function onCreate()
	{
		rainSndAmbience = FunkinSound.load(Paths.sound("rainAmbience"), true, false, true);
    rainSndAmbience.volume = 0;
    rainSndAmbience.play(false, FlxG.random.float(0, rainSndAmbience.length));

		rainShader.scale = FlxG.height / 200; // adjust this value so that the rain looks nice
		rainShader.intensity = rainShaderStartIntensity;
    rainShaderFilter = new ShaderFilter(rainShader);
    FlxG.camera.filters = [rainShaderFilter];
	}

	override function onUpdate()
	{
		if (FlxG.sound.music != null)
    {
      var remappedIntensityValue:Float = FlxMath.remapToRange(Conductor.instance.songPosition, 0, FlxG.sound.music.length, rainShaderStartIntensity,
        rainShaderEndIntensity);
      rainShader.intensity = remappedIntensityValue;
			if (rainSndAmbience != null) rainSndAmbience.volume = Math.min(0.3, remappedIntensityValue * 2);

      rainShader.updateViewInfo(FlxG.width, FlxG.height, FlxG.camera);
      rainShader.update(FlxG.elapsed);
    }
    else
    {
      rainShader.intensity = rainShaderStartIntensity;
			if (rainSndAmbience != null) rainSndAmbience.volume = rainShaderStartIntensity * 2;

      rainShader.updateViewInfo(FlxG.width, FlxG.height, FlxG.camera);
      rainShader.update(FlxG.elapsed);
    }
	}

	override function onSongRetry() { FlxG.camera.filters = [rainShaderFilter]; }
	override function onGameOver() { FlxG.camera.filters = []; }
	override function onDestroy() { rainSndAmbience?.stop(); }

	override function onPause()
	{
		// Temporarily stop ambiance.
		rainSndAmbience?.pause();
	}
	override function onResume()
	{
		// Temporarily stop ambiance.
		rainSndAmbience?.resume();
	}
}