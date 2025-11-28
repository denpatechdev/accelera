package;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.system.FlxBasePreloader;
import flixel.system.FlxPreloader;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.AntiAliasType;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

@:font("assets/data/vga.ttf") class CustomFont extends Font { }
 
class Preloader extends FlxBasePreloader
{
 
    public function new(MinDisplayTime:Float=0, ?AllowedURLs:Array<String>)  
    {
        super(MinDisplayTime, AllowedURLs);
         
    }
     
    var text:TextField;
     
    override function create():Void 
    {
        text = new TextField();
        text.x = 20;
        text.y = 20;
        text.defaultTextFormat = new TextFormat("Perfect DOS VGA 437", 16, 0xFFFFFF);  //Sets the graphic of the sprite to a Bitmap object, which uses our embedded BitmapData class.
        text.text = "0% loaded";
        text.autoSize = TextFieldAutoSize.RIGHT;
        text.antiAliasType = AntiAliasType.ADVANCED;
        text.sharpness = 400;
        addChild(text); //Adds the graphic to the NMEPreloader's buffer.
         
        super.create();
    }

    override function update(Percent:Float) {
        
        text.text = '${Math.floor(Percent*100)}% loaded  ';
        super.update(Percent);
    }
}