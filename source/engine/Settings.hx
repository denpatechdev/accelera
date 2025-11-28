package engine;

class Settings {
    public static var DEBUG = #if debug true #else false #end;

    public inline static function info(text:String) {
        #if debug trace('[INFO] ${text}'); #end
    }

    public inline static function warn(text:String) {
        #if debug trace('[WARNING] ${text}'); #end
    }

    public inline static function err(text:String) {
        #if debug trace('[ERROR] ${text}'); #end
    }
}