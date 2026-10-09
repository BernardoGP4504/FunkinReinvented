import funkin.Paths;
import funkin.play.PlayState;
import funkin.play.PlayStatePlaylist;
import funkin.play.song.Song;
import funkin.util.Sequence;
import funkin.save.Save;
import funkin.audio.FunkinSound;
import funkin.data.song.SongRegistry;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import funkin.Conductor;
import funkin.util.HapticUtil;
import funkin.ui.FullScreenScaleMode as FSSM;
#if mobile
import funkin.util.TouchUtil;
#end

class BlissfulAltSong extends Song
{
	var skipText:FlxText;
	var cutieSfx:FunkinSound;
	var cutsceneMusic:FunkinSound;
	var cutsceneSkipped = false;
	var canSkipCutscene = false;
	var hasPlayedCutscene = false;
	var cutsceneSeq:Sequence;
	var conduct:Conductor;
	var lang:String;

	var cutsceneSfx:FunkinSound;
	var hasPlayedOutro = false;
	var qtCutscene:QtTransformSongOutro;

	var tweens = [];
	var pausedTweens = [];

	function new() { super('blissful', {variation: 'alt'}); }

	override function onCreate(event)
	{
		super.onCreate(event);

		// --- RESET DE ESTADO ---
		hasPlayedCutscene = false;
		hasPlayedOutro = false;
		cutsceneSkipped = false;
		canSkipCutscene = false;
		lang = Save.instance.modOptions.get('qt-rewiredLang');
	}

	override function onSongRetry(event)
	{
		super.onSongRetry(event);

		hasPlayedCutscene = false;
		hasPlayedOutro = false;
		cutsceneSkipped = false;
		canSkipCutscene = false;
		conduct = null;
	}

	override function onDestroy(event)
	{
		super.onDestroy(event);
		resetTweens();
	}

	override function onPause(event)
	{
		super.onPause(event);
		for (tween in tweens)
		{
			if (tween != null)
			{
				tween.active = false;
				pausedTweens.push(tween);
			}
		}
	}

	override function onResume(event)
	{
		super.onResume(event);
		for (tween in pausedTweens)
		{
			if (tween != null) tween.active = true;
		}
		pausedTweens = [];
	}

	function resetTweens()
	{
		for (tween in tweens)
		{
			if (tween != null) tween.cancel();
		}
		tweens = [];
		pausedTweens = [];
	}

	function bopGf()
	{
		PlayState.instance.currentStage.getGirlfriend().dance(true);
	}
	override public function onCountdownStart(event)
	{
		super.onCountdownStart(event);

		if (hasPlayedCutscene)
		{
			Conductor.instance.mapTimeChanges(PlayState.instance.currentChart.timeChanges);
			conduct = null;
			return;
		}

		PlayState.instance.camHUD.visible = false;
		PlayState.instance.camHUD.alpha = 0;

		event.cancel();

		skipText = new FlxText(936 * FSSM.wideScale.x, 618 * FSSM.wideScale.y, 0, null, 20);
		skipText.text = 'Skip [${PlayState.instance.controls.getDialogueNameFromToken("CUTSCENE_ADVANCE", true)}]';
		#if mobile
		skipText.text = 'Skip [Pause Button]';
		skipText.x -= 136;
		#end
		skipText.setFormat(Paths.font('vcr.ttf'), 40, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
		skipText.scrollFactor.set();
		skipText.borderSize = 2;
		skipText.alpha = 0;
		PlayState.instance.add(skipText);
		skipText.cameras = [PlayState.instance.camCutscene];

		var opp = PlayState.instance.currentStage.getDad();
		var player = PlayState.instance.currentStage.getBoyfriend();
		cutieSfx = FunkinSound.load('sounds/gameplay/countdown/$lang/hi_cutie.ogg');

		PlayState.instance.tweenCameraToPosition(opp.cameraFocusPoint.x, opp.cameraFocusPoint.y - 235, 0);

		if (Preferences.subtitles) PlayState.instance.subtitles.assignSubtitles('subtitles/$lang/hi-cutie', cutieSfx);

		cutsceneMusic = FunkinSound.load(Paths.music('gameplay/introSong/introSong-default', 'shared'), true);
		cutsceneMusic.play();
		cutsceneMusic.volume = 0.1;

		conduct = new Conductor();
		var songData = SongRegistry.instance.parseMusicDataRaw('{
  "timeFormat": "ms",
  "artist": "Pohsan",
  "songName": "Intro Countdown (Boyfriend Mix)",
  "timeChanges": [
    {
      "d": 4,
      "n": 4,
      "t": 0,
      "bt": [4, 4, 4, 4],
      "bpm": 130
    }
  ],
  "generatedBy": "Manual",
  "looped": false,
  "version": "2.0.0"
}
');
		conduct.mapTimeChanges(songData.timeChanges);
		conduct.onBeatHit.add(bopGf);

		PlayState.instance.camCutscene.fade(0xFF000000, 2.75, true, null, true);
		PlayState.instance.currentStage.getDad().playAnimation('still', true, true);
		PlayState.instance.tweenCameraToPosition(opp.cameraFocusPoint.x, opp.cameraFocusPoint.y, 2.75, FlxEase.expoOut);
		PlayState.instance.tweenCameraZoom(PlayState.instance.stageZoom * 1.1875, 2.75, true, FlxEase.expoOut);

		hasPlayedCutscene = true;

		var cutsceneSequenceData = [
			{
				time: 0.5,
				callback: () ->
				{
					PlayState.instance.currentStage.getDad().playAnimation("intro", true, false);
				}
			},
			{
				time: 1.09,
				callback: () ->
				{
					cutieSfx.play();
					cutieSfx.volume = 1;
				}
			},
			{
				time: 1.5,
				callback: () ->
				{
					PlayState.instance.currentStage.getBoyfriend().playAnimation("hey", true, false);
				}
			},
			{
				time: 4,
				callback: () ->
				{
					canSkipCutscene = false;
					var zoom = PlayState.instance.stageZoom;
					PlayState.instance.tweenCameraZoom(zoom, 4, true, FlxEase.smoothStepInOut);
					PlayState.instance.startCountdown();
					showHUD();
					skipText.kill();
					skipText.destroy();
					skipText = null;
				}
			}
		];

		cutsceneSeq = new Sequence(cutsceneSequenceData);
	}

	override public function onUpdate(event)
	{
		super.onUpdate(event);

		if (conduct != null)
		{
			conduct.update(cutsceneMusic?.time);
		}

		#if mobile
		var isMobilePauseButtonPressed = TouchUtil.overlapsComplex(PlayState.instance.pauseButton) && TouchUtil.justPressed;
		#end

		if ((PlayState.instance.controls.CUTSCENE_ADVANCE #if mobile || isMobilePauseButtonPressed #end) && !cutsceneSkipped)
		{
			if (!canSkipCutscene)
			{
				if (skipText != null)
				{
					FlxTween.tween(skipText, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
					new FlxTimer().start(0.5, _ -> canSkipCutscene = true);
				}
			}
		}

		if ((PlayState.instance.controls.CUTSCENE_ADVANCE #if mobile || isMobilePauseButtonPressed #end) && !cutsceneSkipped && canSkipCutscene)
		{
			skipCutscene();
		}
	}

	public function skipCutscene():Void
	{
		cutsceneSkipped = true;
		canSkipCutscene = false;

		if (cutsceneSeq != null)
		{
			cutsceneSeq.running = false;
			cutsceneSeq = null;
		}

		PlayState.instance.camCutscene.fade(0xFF000000, 0.5, false, null, true);
		new FlxTimer().start(0.5, _ ->
		{
			PlayState.instance.justUnpaused = true;
			PlayState.instance.camCutscene.fade(0xFF000000, 0.5, true, null, true);

			if (cutsceneMusic != null) cutsceneMusic.stop();
			if (cutieSfx != null) cutieSfx.stop();

			if (skipText != null) skipText.visible = false;
			var opp = PlayState.instance.currentStage?.getDad();
			opp.dance(true);
			PlayState.instance.currentStage.getBoyfriend().dance(true);
			PlayState.instance.tweenCameraToPosition(opp.cameraFocusPoint.x, opp.cameraFocusPoint.y, 0, FlxEase.expoOut);
			PlayState.instance.tweenCameraZoom(PlayState.instance.stageZoom, 0, true, FlxEase.expoOut);
			showHUD();
			PlayState.instance.startCountdown();
		});

		skipText.kill();
		skipText.destroy();
		skipText = null;
	}

	public function showHUD(duration:Float = 1):Void
	{
		PlayState.instance.camHUD.visible = true;
		PlayState.instance.camHUD.alpha = 0;
		FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, duration, {ease: FlxEase.smoothStepInOut});
	}

	override public function onSongEnd(event)
	{
		super.onSongEnd(event);

		if (!PlayStatePlaylist.isStoryMode || PlayState.instance.currentVariation == 'pico')
			hasPlayedOutro = true;

		if (!hasPlayedOutro)
		{
			hasPlayedOutro = true;
			event.cancel();
			event.stopPropagation();
			introCutscene();
		}
		else
		{
			hasPlayedOutro = false;
		}
	}

	private function introCutscene():Void
	{
		var playState = PlayState.instance;
		var playStage = playState.currentStage;

		playState.isInCutscene = true;

		var gfPos = [
			playStage.getGirlfriend().cameraFocusPoint.x,
			playStage.getGirlfriend().cameraFocusPoint.y
		];

		cutsceneSfx = FunkinSound.load(Paths.sound("qtsfx"), true);
		cutsceneSfx.volume = 1;
		tweens.push(FlxTween.tween(playState.camHUD, {alpha: 0}, 1));

		var dad = playStage.getDad();
		qtCutscene = new QtTransformSongOutro();
		qtCutscene.setPosition(dad.x - 45, dad.y - 269);
		qtCutscene.shader = dad.shader;
		qtCutscene.zIndex = dad.zIndex;
		playStage.getNamedProp("lightOverlay").zIndex = 401;
		qtCutscene.zIndex = 400;
		playStage.getDad().visible = false;
		playStage.add(qtCutscene);
		playStage.refresh();

		playState.tweenCameraZoom(0.68, 1, true, FlxEase.quadInOut);
		qtCutscene.doAnim();

		var opponentPos = [
			playStage.getDad().cameraFocusPoint.x,
			playState.cameraFollowPoint.y
		];

		new FlxTimer().start(1, _ -> cutsceneSfx.play());

		new FlxTimer().start(1, _ ->
		{
			playState.tweenCameraToPosition(opponentPos[0], opponentPos[1], 2.55, FlxEase.quadInOut);
		});

		new FlxTimer().start(2.26, _ ->
		{
			tweens.push(FlxTween.tween(playStage.getNamedProp("lightOverlay"), {alpha: 0}, 1.10, {ease: FlxEase.linear}));
			tweens.push(FlxTween.tween(playStage.getNamedProp("blackScreen"), {alpha: 1}, 1.10, {ease: FlxEase.linear}));
			tweens.push(FlxTween.tween(playStage.getNamedProp("spotLight"), {alpha: 1}, 1.10, {ease: FlxEase.linear}));
		});

		new FlxTimer().start(12, _ ->
		{
			PlayState.instance.camGame.shake(0.002, 8);
			if (FlxG.onMobile) HapticUtil.increasingVibrate(0.05, 0.2, 8);
			tweens.push(FlxTween.tween(playStage.getNamedProp("redScreen"), {alpha: 1}, 0.7, {ease: FlxEase.linear}));
			tweens.push(FlxTween.tween(playStage.getNamedProp("spotLight"), {alpha: 0}, 0.7, {ease: FlxEase.linear}));
		});

		new FlxTimer().start(13, _ ->
		{
			playState.camCutscene.fade(0xFFFFFFFF, 2, false, () -> qtCutscene.destroy());
		});

		new FlxTimer().start(15.7, _ -> playState.camCutscene.fade(0xFF000000, 0.0001, false));

		new FlxTimer().start(17.5, _ -> playState.endSong(true));
	}
}