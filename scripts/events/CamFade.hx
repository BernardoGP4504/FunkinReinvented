import flixel.FlxCamera;
import flixel.util.FlxColor;
import funkin.play.event.SongEvent;
import funkin.play.PlayState;
import Reflect;

class ReinventedCamFadeEvent extends SongEvent
{
	function new() { super('CamFade', {processOldEvents: false}); }

	override function getEventSchema():SongEventSchema
	{
		return [
			{
				name: "tgtCam",
				title: "Target Camera",
				type: "enum",
				keys: [
					"Game Camera" => "camGame",
					"HUD Camera" => "camHUD",
					"Cutscene Camera" => "camCutscene"
				],
				defaultValue: "camGame"
			},
			{
				name: "time",
				title: "Fade Duration (if fast enough, acts as a \"Camera Flash\")",
				type: "float",
				min: 0,
				units: "seconds",
				defaultValue: 1
			},
			{
				name: "color",
				title: "Fade Color",
				type: "string",
				defaultValue: "black"
			},
			{
				name: "fadeIn",
				title: "Is Fade In",
				type: "bool",
				defaultValue: false
			},
			{
				name: "forced",
				title: "Forced",
				type: "bool",
				defaultValue: false
			}
		];
	}

	override function handleEvent(data:SongEventData)
	{
		final params:Dynamic = data.value;
		if (params == null) return;
		
		final cam:FlxCamera = Reflect.field(PlayState.instance, params.tgtCam);
		if (cam == null)
		{
			trace('Camera Fade: Cam "${params.tgtCam}" doesn\'t exist!');
			return;
		}	

		final useFlash:Bool = params.time < 1;
		switch (useFlash)
		{
			case true: cam.flash(FlxColor.fromString(params.color), params.time, params.forced);
			case false: cam.fade(FlxColor.fromString(params.color), params.time, params.fadeIn, params.forced);
		}
	}

	override function getTitle() { return 'Camera Fade'; }
}