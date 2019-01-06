package Shared {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Logger {

		public function Debug() : void {
			Logger.Log("Debug  Init");
		}

		public static function Log(text: String, level:String = "Info"): void {
			trace("["+level+"] "+text);
		}

		public static function DeepTrace(obj: * , level: int = 0, isRecursive:Boolean = false): void {
			var tabs: String = "";
			var displayedSomething:Boolean = false;

			if(obj == null) {
				trace("[DeepTrace] Object is null");
			}

			for (var i: int = 0; i < level; i++) {
				tabs += "\t"
			}

			for (var prop: String in obj) {
				trace(tabs + "[" + prop + "] -> " + obj[prop]);
				DeepTrace(obj[prop], level + 1, true);
				displayedSomething = true;
			}

			if(!displayedSomething && !isRecursive) {
				trace("[DeepTrace] Nothing to display (Maybe there's private vars?)");
			}

		}
	}

}//trace("LOAD>> Fader Menu");