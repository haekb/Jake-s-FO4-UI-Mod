package {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Debug extends MovieClip {
		public var debugText: TextField;

		private var history: Array;
		private var historyIndex: int = 0;

		// Used for scrolling
		private var localIndex: int = 0;

		public function Debug() {
			history = new Array();
			//addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false, 0, true);
			this.Log("Debug Console Init");
		}

		public function onKeyUp(evt: KeyboardEvent): * {
			if (!this.visible) {
				return;
			}

			if (evt.keyCode == Keyboard.PAGE_UP) {
				this.showHistoryPrevious();
			} else if (evt.keyCode == Keyboard.PAGE_DOWN) {
				this.showHistoryNext();
			}

			evt.stopPropagation();
		}

		private function showHistoryPrevious(skipCheck: Boolean = false): * {
			if (this.localIndex > 0 || skipCheck) {
				if (!skipCheck) {
					this.localIndex--;
				}

				this.debugText.text = "HISTORY.PREV:" + this.localIndex + ">>" + this.history[this.localIndex];
			} else { // If we hit the bottom, loop back to the top!
				this.localIndex = (this.history.length - 1)
				this.showHistoryNext(true);
			}
		}

		private function showHistoryNext(skipCheck: Boolean = false): * {
			if (this.localIndex < (this.history.length - 1) || skipCheck) {
				if (!skipCheck) {
					this.localIndex++;
				}
				this.debugText.text = "HISTORY.NEXT:" + this.localIndex + ">>" + this.history[this.localIndex];
			} else { // If we hit the bottom, loop back to the top!
				this.localIndex = 0
				this.showHistoryPrevious(true);
			}
		}

		public function Try(closure: Function, tag: String): * {
			try {
				closure();
			} catch (error: Error) {
				this.Log("[" + tag + "]" + "Error occured while trying code.\n\tName: " + error.name + "\n\tMessage: " + error.message + "\n\tStack Trace: " + error.getStackTrace());
			}
		}

		public function Log(text: String): * {
			this.history.push(text);
			this.historyIndex++;
			this.localIndex = this.historyIndex;

			this.debugText.text = text;
			//trace(text);
		}

		public static function deepTrace(obj: * , level: int = 0, isRecursive:Boolean = false): void {
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
				deepTrace(obj[prop], level + 1, true);
				displayedSomething = true;
			}

			if(!displayedSomething && !isRecursive) {
				trace("[DeepTrace] Nothing to display (Maybe there's private vars?)");
			}

		}

	}

}//trace("LOAD>> Fader Menu");