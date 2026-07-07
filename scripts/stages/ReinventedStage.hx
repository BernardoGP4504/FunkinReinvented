import flixel.util.FlxColor;
import funkin.graphics.shaders.DropShadowShader;
import funkin.play.character.BaseCharacter;
import funkin.play.character.CharacterType;
import funkin.play.stage.Stage;

using StringTools;

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

		dropShader.antialiasAmt = character.characterId.contains('-pixel') ? 0 : 2;
		final filteredID:String = character.characterId.replace(charType == CharacterType.DAD ? '-op' : '-playable', "");
		
		final nonReinventedChar:String = filteredID.endsWith('-r') ? filteredID.replace("-r", "") : filteredID;
		final maskPath:String = Paths.image('stages/default/masks/' + nonReinventedChar);
		if (Assets.exists(maskPath))
		{
			dropShader.loadAltMask(maskPath);
			dropShader.useAltMask = true;
			dropShader.maskThreshold = 0.5;
		}

		final char:BaseCharacter = character;
		character.animation.onFrameChange.add(function() if (char != null)
			dropShader.updateFrameInfo(char.frame)
		);
		character.shader = dropShader;
	}
}