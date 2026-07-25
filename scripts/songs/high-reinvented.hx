import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
import funkin.Paths;
import funkin.play.PlayState;
import funkin.play.song.Song;

class HighReinventedSunset extends Song
{
	var shader:FlxRuntimeShader;
	var shaderFilter:ShaderFilter;

	function new() { super('high-reinvented'); }

	override function onCreate()
	{
		final shaderCode:String = Assets.getText( Paths.frag('sunset') );
		shader = new FlxRuntimeShader(shaderCode);
		shaderFilter = new ShaderFilter(shader);

		FlxG.camera.filters ??= [];
		FlxG.camera.filters.push(shaderFilter);
	}

	override function onGameOver() { FlxG.camera.filters.remove(shaderFilter); }
	override function onSongRetry() { if (!FlxG.camera.filters.contains(shaderFilter)) FlxG.camera.filters.push(shaderFilter); }
}