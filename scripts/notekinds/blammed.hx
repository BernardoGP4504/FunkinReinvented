import funkin.play.notes.notekind.NoteKind;
import funkin.util.Constants;

class ReinventedBlammedNote extends NoteKind
{
	function new()
	{
		super('Blammed Notes', "Bullet dodge notes used on Blammed.", "bullets", [], false, "ALT");
		this.scoreable = false;
	}

	override function onNoteMiss(event:NoteScriptEvent)
	{
		event.healthChange = -6.25 / 100 * Constants.HEALTH_MAX;
		event.playSound = false;
	}

	override function onNoteIncoming(event:NoteScriptEvent)
	{
		event.note.offset.x = 42;
	}
}