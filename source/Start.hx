package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class Start extends FlxState {
    
    public function new() {
        super();
    }

    override function create() {
        var text = new FlxText(20, 20, 0, "Accelera\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n
Press any key to continue.\n
Trigger warning for depictions of mental health and nudity.", 16);
        text.font = "assets/data/vga.ttf";
        add(text);
        super.create();
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ANY) {
            FlxG.switchState(PlayState.new);
        }
        super.update(elapsed);
    }
}