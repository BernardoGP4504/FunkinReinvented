import funkin.play.cutscene.dialogue.DialogueBox;

using StringTools;

class DefaultDialogueBoxFix extends DialogueBox
{
	var prevSuffix:String = "";

	function new() { super('default'); }

	override function onCreate(_:ScriptEvent)
	{
		prevSuffix = "";
		super.onCreate(_);
	}

	override function playAnimation(name:String, restart:Bool = false, reversed:Bool = false)
	{
		final curSuffix = name.endsWith('Left') ? 'Left' : "";
		if (/* !name.startsWith('enter') &&  */curSuffix != prevSuffix)
		{
			name = 'enter$curSuffix';
			trace('side mismatch, playing $name anim');
		}

		prevSuffix = curSuffix;
		super.playAnimation(name, restart, reversed);
	}

	override function onAnimationFinished(name:String)
	{
		if (!name.startsWith('enter')) return;
		playAnimation('idle$prevSuffix');
	}
}