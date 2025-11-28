package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class Ending extends FlxState {
    
    public function new() {
        super();
    }

    override function create() {
        var text = new FlxText(20, 20, 0, "Accelera\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n
The End.\nPress any key to return to the start screen.", 16);
        text.font = "assets/data/vga.ttf";
        FlxG.sound.music.stop();
        add(text);
        super.create();
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ANY) {
            FlxG.switchState(Start.new);
        }
        super.update(elapsed);
    }
}