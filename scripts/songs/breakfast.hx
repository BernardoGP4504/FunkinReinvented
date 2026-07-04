import funkin.modding.module.Module;
import funkin.play.PauseSubState;
import funkin.play.PlayState;
import funkin.ui.freeplay.FreeplayState;

using StringTools;

class BreakfastReinventedMix extends Module
{
	function new() { super('BreakfastReinvented', 1000, {state: PlayState}); }

	override function onSongLoaded()
	{
		if (!FreeplayState.rememberedCharacterId.contains("reinvented")) return;
		PauseSubState.musicSuffix = '-${FreeplayState.rememberedCharacterId}';
	}
}