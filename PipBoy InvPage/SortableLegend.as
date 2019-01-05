package {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
   	import scaleform.gfx.MouseEventEx;
	import Shared.CustomEvent;


	public class SortableLegend extends MovieClip {

		public var id: int;
		public var border: MovieClip;
		public var infoBox: TextField;
		public var arrow: MovieClip;

		public var onMouseIn: Boolean;

		public const SORT_NONE: uint = 3;
		public const SORT_ASCENDING: uint = 1;
		public const SORT_DESCENDING: uint = 2;

		public var currentSort:int = 3;

		// Colours!
		private const SelectedColorTransform: ColorTransform = new ColorTransform(1, 1, 1, 1, -255, -255, -255, 0);
		private const UnselectedColorTransform: ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);

		public function SortableLegend() {
			addFrameScript(0, this.freezeFrame, 1, this.freezeFrame, 2, this.freezeFrame);


			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageEvent);

			this.setSort(this.SORT_NONE);
		}


		private final function onAddedToStageEvent(param1: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageEvent);
			this.onAddedToStage();
		}

		public function onAddedToStage() : * {
			this.addEventListener(MouseEvent.MOUSE_OUT, this.onEntryRollout, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, this.onEntryRollover, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, this.onEntryPress, false, 0, true);

			//trace("Adding Event Listener");
			//this.addEventListener("SortableLegend::ChangeLegend", this.ChangeLegend, false, 0, true);

			//this.addEventListener("SortableLegend::Sort", this.setSortToNone, false, 0, true);

		}
		
		public function setSortToNone(evt: CustomEvent) : void
		{
			this.dispatchEvent(new CustomEvent("Debug::Log", "setSortToNone: Found me!", true, true));

			// Don't cancel us!
			if(this.id == evt.params.id)
			{
				this.dispatchEvent(new CustomEvent("Debug::Log", "setSortToNone: Found me!", true, true));

				return;
			}
			this.dispatchEvent(new CustomEvent("Debug::Log", "setSortToNone: Found not me!", true, true));

			this.currentSort = this.SORT_NONE;
			this.setSort(this.SORT_NONE, false);
		}

		public function reBindClips() : void {
			this.border = this.getChildByName("border") as MovieClip;
			this.infoBox = this.getChildByName("infoBox") as TextField;
			this.arrow = this.getChildByName("arrow") as MovieClip;

		}

		public function onEntryRollover(evt: Event) : void {
			this.dispatchEvent(new CustomEvent("Debug::Log", "Legend roll over!", true, true));
			this.onMouseIn = true;
			this.adjustColour();
		}

		public function onEntryRollout(evt: Event) : void {
			this.dispatchEvent(new CustomEvent("Debug::Log", "Legend roll out!", true, true));
			this.onMouseIn = false;
			this.adjustColour();
		}

		private function adjustColour() : void {
			// Needs init
			if (this.border == null || this.infoBox == null) {
				this.dispatchEvent(new CustomEvent("Debug::Log", "adjustColor failed because of null elements", true, true));

				return;
			}

			if (this.onMouseIn) {
				this.border.transform.colorTransform = this.UnselectedColorTransform;
				this.infoBox.transform.colorTransform = this.SelectedColorTransform;

				if (this.arrow != null) {
					this.arrow.transform.colorTransform = this.SelectedColorTransform;
				}

			} else {
				this.border.transform.colorTransform = this.SelectedColorTransform;
				this.infoBox.transform.colorTransform = this.UnselectedColorTransform;

				if (this.arrow != null) {
					this.arrow.transform.colorTransform = this.UnselectedColorTransform;
				}
			}
		}

		public function onEntryPress(evt: Event) : void {
			var mouseEvt:MouseEventEx = evt as MouseEventEx;
			var mouseIndex:uint = mouseEvt == null?uint(0):uint(mouseEvt.mouseIdx);
			var buttonIndex:uint = mouseEvt == null?uint(0):uint(mouseEvt.buttonIdx);

			trace("Pressing "+mouseIndex);
			trace("Button: " + buttonIndex);

			if(buttonIndex == 0) {
				this.onMouse1(evt);
			}
		}

		private function onMouse1(evt: Event) : void
		{
			trace("On Mouse 1!");
			this.dispatchEvent(new CustomEvent("Debug::Log", "Clicking to change sort!" + this.currentSort +"/"+ this.currentFrame, true, true));
			
			this.currentSort++;

			if (this.currentSort == 4) {
				this.currentSort = 1;
			}

			this.setSort(this.currentSort);
		}

		public function ChangeLegend(evt: Event) : void
		{
			// Don't change unselected legends
			if(!this.onMouseIn) {
				trace(this.onMouseIn + " is false! Skipping legend");
				return;
			}


			trace("Change Legend Pressed For "+this.infoBox.text);
		}

		public function freezeFrame() : void {
			stop();
		}

		public function setSort(sort: int, useEvent: Boolean = true) : void {
			this.gotoAndStop(sort);
			this.reBindClips();
			this.adjustColour();

			if(useEvent) {
				this.dispatchEvent(new CustomEvent("SortableLegend::Sort", {sort: sort, id: this.id}, true, true));
			}
		}
	}

}