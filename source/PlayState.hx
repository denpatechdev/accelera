package;

import engine.Settings;
import engine.data.Branches;
import engine.data.Choice;
import engine.data.DialogueBlock;
import engine.data.DialogueEvent;
import engine.parsers.DialogueParser;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;

class PlayState extends FlxState
{

	var bg:FlxSprite;
	var sprites:Map<String, FlxSprite>;
	var spriteGroup:FlxTypedGroup<FlxSprite>;
	var branches:Branches;
	var dialogue:Array<DialogueBlock>;
	var curDialogue:DialogueBlock;
	var curIndex:Int = 0;
	var typingDone:Bool = true;
	var nameText:FlxText;
	var dialogueText:FlxTypeText;
	var dialogueUI:FlxTypedGroup<FlxSprite>;

	var curChoices:Array<Choice>;

	var translucent:FlxSprite;

	public function new() {
		sprites = [];
		curChoices = [];
		super();
	}

	override public function create()
	{
		spriteGroup = new FlxTypedGroup<FlxSprite>();
		add(spriteGroup);
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		sprites['bg'] = bg;
		spriteGroup.add(bg);
		translucent = new FlxSprite().makeGraphic(FlxG.width, Std.int(FlxG.height / 4.5), FlxColor.BLACK);
		translucent.alpha = 0.7;
		sprites['translucent'] = translucent;
		spriteGroup.add(translucent);
		branches = DialogueParser.read(Assets.getText("assets/data/start.txt"));
		dialogue = branches['main'];
		curDialogue = dialogue[0];
		super.create();
		dialogueUI = new FlxTypedGroup<FlxSprite>();
		add(dialogueUI);
		nameText = new FlxText(20, 20, 0, curDialogue.name, 16);
		dialogueText = new FlxTypeText(nameText.x, nameText.y + 32, FlxG.width - 40, curDialogue.text, 16);
		
		dialogueText.completeCallback = () -> {
			typingDone = true;
			showChoices();
		}

		nameText.font = dialogueText.font = "assets/data/vga.ttf";

		nameText.color = dialogueText.color = FlxColor.WHITE;

		dialogueUI.add(nameText);
		dialogueUI.add(dialogueText);

		runDialogue();
	}

	var selectingChoices:Bool = false;

	override public function update(elapsed:Float)
	{

		if (FlxG.keys.justPressed.ENTER) {
			if (!typingDone) {
				skipDialogue();
				Settings.info('Skipping text (index: ${curIndex})');
			}
			else if (!selectingChoices && typingDone && curIndex < dialogue.length - 1)
			{
				curIndex++;
				curDialogue = dialogue[curIndex];
				runDialogue();
				Settings.info('Running dialogue (index: ${curIndex})');
			}
		}
		super.update(elapsed);
	}

	inline function runDialogue() {
		nameText.text = curDialogue.name;
		dialogueText.resetText(curDialogue.text);
		dialogueText.start(curDialogue.typingSpeed);
		typingDone = false;
		manageEvents(curDialogue);
	}

	inline function skipDialogue() {
		dialogueText.skip();
		typingDone = true;
		showChoices();
	} 

	inline function manageEvents(dialogue:DialogueBlock) {
		for (ev in dialogue.events) {
			handleEvent(ev);
		}
	}

	function handleEvent(ev:DialogueEvent) {
		var name = ev.name;
		var args = ev.args;
		Settings.info('Handling event: ${name} ${args}');
		switch (name) {
			case CreateSprite:
				var id = args[0];
				var path = args[1];
				var x = Std.parseFloat(args[2]);
				var y = Std.parseFloat(args[3]);
				createSprite(id, path, x, y);
			case DeleteSprite:
				var id = args[0];
				delSprite(id);
			case ChangeSprite:
				var id = args[0];
				var path = args[1];
				changeSprite(id, path);
			case MoveSprite:
				var id = args[0];
				var x = Std.parseFloat(args[1]);
				var y = Std.parseFloat(args[2]);
				moveSprite(id, x, y);
			case PlaySound:
				FlxG.sound.play(args[0]);
			case SetBG:
				if (args[0] == 'BlackScreen') {
					bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
				} else {
					bg.loadGraphic(args[0]);
				}
			case SetBGM:
				if (args[0] == 'None')
					FlxG.sound.music.stop();
				else
					FlxG.sound.playMusic(args[0]);
			case SetDialogue:
				curIndex = -1;
				branches = DialogueParser.read(Assets.getText(args[0]));
				dialogue = branches[args[1]];
			case SetBranch:
				curIndex = -1;
				dialogue = branches[args[0]];
			case Choice:
				curChoices.push({
					text: args[0],
					branch: args[1]
				});
			case "End":
				FlxG.switchState(Ending.new);
			default:
				Settings.warn('Invalid event ${name}(${args})');
		}
	}

	function save() {
		
	}

	var choices:Array<FlxButtonPlus> = [];

	function showChoices()
	{
		if (curChoices.length == 0)
			return;

		selectingChoices = true;

		for (i in 0...curChoices.length)
		{
			var choice = curChoices[i];
			var choiceButton:FlxButtonPlus;
			choiceButton = new FlxButtonPlus(i * 100 + 20, () -> {}, choice.text);
			choiceButton.y = FlxG.height - (choiceButton.height + 20);
			choiceButton.onClickCallback = () ->
			{
				curIndex = 0;
				trace(choice.branch);
				dialogue = branches[choice.branch];
				curDialogue = dialogue[curIndex];
				for (c in choices)
				{
					c.kill();
					spriteGroup.remove(choiceButton);
				}
				selectingChoices = false;
				curChoices = [];
				choices = [];
				runDialogue();
			}
			choices.push(choiceButton);
			spriteGroup.add(choiceButton);
		}
	}

	function createSprite(id:String, path:String, x:Float, y:Float) {
		var spr = new FlxSprite(x, y, path);
		sprites[id] = spr;
		spriteGroup.add(spr);
	}

	function delSprite(id:String) {
		sprites[id].kill();
		spriteGroup.remove(sprites[id]);
		sprites.remove(id);
	}

	function changeSprite(id:String, path:String) {
		sprites[id].loadGraphic(path);
	}

	function moveSprite(id:String, x:Float, y:Float) {
		sprites[id].setPosition(x, y);
	}
}
