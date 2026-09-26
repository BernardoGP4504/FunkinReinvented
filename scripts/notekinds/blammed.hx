import funkin.play.PlayState;
import funkin.play.notes.notekind.NoteKind;
import funkin.util.Constants;
import funkin.play.character.BaseCharacter;

class ReinventedBlammedNote extends NoteKind
{
	function new() { super('Blammed Notes', "Bullet dodge notes used on Blammed.", "bullets", null, true); }

	override function onNoteHit(event:NoteScriptEvent)
	{
		event.score = 0; // Pq q salvar sua vida te daria pontos? Vc nn tá em um jogo man
		playCharacterAnimations('shoot', true, 'dodge');
	}

	override function onNoteMiss(event:NoteScriptEvent)
	{
		event.healthChange = -10 / 100 * Constants.HEALTH_MAX;
		event.playSound = false;

		playCharacterAnimations('shoot', true, 'hit');
	}

	override function onNoteIncoming(event:NoteScriptEvent)
	{
		event.note.offset.x = 42;
		playCharacterAnimations('cock', false);
	}

	function playCharacterAnimations(opponentAnim:String, opponentForced:Bool = true, ?playerAnim:String, playerForced:Bool = true)
	{
		final boyfriend:Null<BaseCharacter> = PlayState.instance.currentStage.getBoyfriend();
		final dad:Null<BaseCharacter> = PlayState.instance.currentStage.getDad();
		if (dad == null && (boyfriend == null || playerAnim == null)) return;

		if (dad != null)
		{
			dad.playAnimation(opponentAnim, opponentForced);
			dad.holdTimer = 0;
		}

		if (boyfriend != null && playerAnim != null)
		{
			boyfriend.playAnimation(playerAnim, playerForced);
			boyfriend.holdTimer = 0;
		}
	}
}