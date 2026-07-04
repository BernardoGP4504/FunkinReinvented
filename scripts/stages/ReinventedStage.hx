import flixel.util.FlxColor;
import funkin.graphics.shaders.DropShadowShader;
import funkin.play.character.BaseCharacter;
import funkin.play.character.CharacterType;
import funkin.play.stage.Stage;

class ReinventedMainStage extends Stage
{
	function new() { super('mainStageReinvented'); }

	override function addCharacter(character:Character, charType:CharacterType)
	{
		super.addCharacter(character, charType);
		if (character == null) return;

		var dropShader:DropShadowShader = new DropShadowShader();
		dropShader.attachedSprite = character;
		dropShader.angle = switch (charType)
		{
			case CharacterType.DAD: 120;
			case CharacterType.BF: 60;
			default: 90;
		};
		dropShader.threshold = 0.1;
		dropShader.color = 0xFF606060;
		dropShader.setAdjustColor(-28, -4, -13, -22);
		dropShader.distance = 16;

		final char:BaseCharacter = character;
		character.animation.onFrameChange.add(function() if (char != null)
			dropShader.updateFrameInfo(char.frame)
		);
		character.shader = dropShader;
	}
}