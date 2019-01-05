package {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import Shared.CustomEvent;


	public class InvLegend extends MovieClip {

		public var border: MovieClip;

		public var textField: TextField;
		// Info Boxes
		public var sortableBox1_mc: SortableLegend;
		public var sortableBox2_mc: SortableLegend;
		public var sortableBox3_mc: SortableLegend;
		public var sortableBox4_mc: SortableLegend;
		public var sortableBox5_mc: SortableLegend;
		public var sortableBox6_mc: SortableLegend;

		private var infoBoxData: * = [
			["Damage", "ROF", "Range", "Accuracy", "Weight", "Value"],
			["Defense", "", "", "", "Weight", "Value"],
			["", 		"", "", "", "Weight", "Value"],
			["", 		"", "", "", "Weight", "Value"],
			["", 		"", "", "", "Weight", "Value"]
		];

		private const Weapons: int = 0;
		private const Armour: int = 1;
		private const Aid: int = 2;
		//???
		private const Misc: int = 3;
		private const Junk: int = 4;
		private const Mods: int = 5;
		private const Ammo: int = 6;

		public function InvLegend() {
			// constructor code
			this.addEventListener("SortableLegend::Sort", this.setSortToNone, false, 0, true);

			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageEvent);
		}


		private final function onAddedToStageEvent(param1: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageEvent);
						
			this.addEventListener("SortableLegend::ChangeLegend", this.ChangeLegend, false, 0, true);

			// I'm unsure if flash creates some internal id for compares,
			// so just make my own.
			this.sortableBox1_mc.id = 1;
			this.sortableBox2_mc.id = 2;
			this.sortableBox3_mc.id = 3;
			this.sortableBox4_mc.id = 4;
			this.sortableBox5_mc.id = 5;
			this.sortableBox6_mc.id = 6;
		}

		public function ChangeLegend(evt: Event) : void
		{
			for(var i = 1; i < 7; i++) {
				this["sortableBox"+i+"_mc"].ChangeLegend(evt);
			}
		}
		
		public function setSortToNone(evt: CustomEvent)
		{
			this.dispatchEvent(new CustomEvent("Debug::Log", "setSortToNone: Caught by InvLegend", true, true));

			for(var i = 1; i < 7; i++) {
				this["sortableBox"+i+"_mc"].setSortToNone(evt);
			}
		}

		public function handleTabChange(tab: int) {
			var iMinusOne, i;
			try {
				for (i = 1; i < 7; i++) {
					iMinusOne = i - 1;
					this["sortableBox" + i + "_mc"].infoBox.text = this.infoBoxData[tab][iMinusOne];
				}

			} catch (error: Error) {
				for (i = 1; i < 7; i++) {
					iMinusOne = i - 1;
					this["sortableBox" + i + "_mc"].infoBox.text = this.infoBoxData[this.Misc][iMinusOne];
				}

			}
		}
	}

}