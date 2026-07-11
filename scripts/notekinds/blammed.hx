import funkin.play.PlayState;
import funkin.play.notes.notekind.NoteKind;
import funkin.util.Constants;

class ReinventedBlammedNote extends NoteKind
{
	function new()
	{
		super('Blammed Notes', "Bullet dodge notes used on Blammed.", "bullets", [], false, "ALT");
		this.scoreable = true;
	}

	override function onNoteHit(event:NoteScriptEvent)
	{
		PlayState.instance.currentStage.getDad()?.playAnimation('shoot', true, true);
	}

	override function onNoteMiss(event:NoteScriptEvent)
	{
		PlayState.instance.currentStage.getDad()?.playAnimation('shoot', true, true);

		event.healthChange = -10 / 100 * Constants.HEALTH_MAX;
		event.playSound = false;
	}

	override function onNoteIncoming(event:NoteScriptEvent)
	{
		PlayState.instance.currentStage.getDad()?.playAnimation('cock');
		event.note.offset.x = 42;
	}
}