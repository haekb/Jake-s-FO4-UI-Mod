package {
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.BSScrollingListEntry;
	import flash.events.Event;
	import Shared.CustomEvent;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	import flash.events.KeyboardEvent;
	import Shared.AS3.ListFilterer;

	public dynamic
	class InvList extends BSScrollingList {


		public var iLastClipIndex: uint = 9999;
		public var expandedHeight: * = 0;

		public function InvList() {
			super();
		}

		public function getNumEntries(): * {
			return this.EntryHolder_mc.numChildren;
		}

		override public function onComponentInit(evt: Event): * {
			super.onComponentInit(evt);

			/*
			var entry: BSScrollingListEntry = this.GetClipByIndex(0);

			entry.gotoAndStop("Expanded");
			entry.height = 120;
			this.iLastClipIndex = 0;
			*/
		}

		/**
		 * Override to handle expanding list
		 */
		override public function onEntryRollover(evt: Event): * {
			var errorMarker:* = 0;
			var ifMarker:* = 0;
			try {
				var entry: InvListEntry;

				entry = this.GetClipByIndex((evt.currentTarget as InvListEntry).clipIndex) as InvListEntry;

				this.deflatePreviousSelection(entry);

				super.onEntryRollover(evt);

				this.expandSelection(entry);
			} catch (error: Error) {
				this.dispatchEvent(new CustomEvent("Debug::Log", "[onEntryRollover] Error Occured :\n" + error.name + "\n" + error.message + "\n On ERROR Marker" + errorMarker + "\n On IF Maker" + ifMarker, true, true));
			}
		}

		public function sortList(sortBy: String): * {

			trace("SortList by "+sortBy);
			//trace("Before Name/Damage" + this.EntriesA.textField.text + "/" + this.EntriesA.damageStats);

			//this.EntriesA.sortOn("damageStats");
			
			var items:Array = this._filterer.filterArray;
			Debug.deepTrace(items);
			
			//this.UpdateList();
			// List of entries, InvListEntry
			// Each should hold a infoObj
			// Need to sort by that, and bring that sort back up to the top
			// Miiiight be slow.

			// Possibly build new list


		}

		/**
		 * Something sets the first entry as the selected entry.
		 * So we need to expand that...
		 */
		public function setDefaultExpandedEntry() : *
		{
			try {
				var entry:InvListEntry = this.GetClipByIndex(this.selectedClipIndex) as InvListEntry;
				this.expandSelection(entry);
			} catch (error: Error) {
				trace( "[setDefaultExpandedEntry] Error expanding " + error.name + "\n" + error.message);
			}
		}

		public function resetEntries() : *
		{
			try {
				for(var i:int = 0; i < this.numListItems; i++) {
					var entry:InvListEntry = this.GetClipByIndex(i) as InvListEntry;
					this.deflateSelection(entry);
				}
			} catch (error: Error) {
				trace( "[setDefaultExpandedEntry] Error expanding " + error.name + "\n" + error.message);
			}
		}
		
		override public function UpdateList(): * {
			// now unused, was used to set defaults on entries. Replaced by entry.
			// var _loc7_: BSScrollingListEntry = null;
			var entry: BSScrollingListEntry = null;
			if (!this.bInitialized || this.numListItems == 0) {
				trace("BSScrollingList::UpdateList -- Can\'t update list before list has been created.");
			}
			var verticalSpacing: Number = 0;
			var _loc2_: Number = this._filterer.ClampIndex(0);
			var _loc3_: Number = _loc2_;
			var index: uint = 0;

			// Default set all entries' clipIndexes to MAX INT
			while (index < this.EntriesA.length) {
				this.EntriesA[index].clipIndex = int.MAX_VALUE;
				if (index < this.iScrollPosition) {
					_loc2_ = this._filterer.GetNextFilterMatch(_loc2_);
				}
				index++;
			}
			var listIndex: uint = 0;

			// Default set all entries item indexes' to MAX INT and make them not visible
			while (listIndex < this.uiNumListItems) {
				entry = this.GetClipByIndex(listIndex);
				if (entry) {
					entry.visible = false;
					entry.itemIndex = int.MAX_VALUE;
				}
				listIndex++;
			}

			// TODO: Mobile only code, so figure it out later!
         	var _loc6_:Vector.<Object> = new Vector.<Object>();
			this.iListItemsShown = 0;
			if (this.needMobileScrollList) {
				while (_loc3_ != int.MAX_VALUE && _loc3_ != -1 && _loc3_ < this.EntriesA.length && verticalSpacing <= this.fListHeight) {
					_loc6_.push(this.EntriesA[_loc3_]);
					_loc3_ = this._filterer.GetNextFilterMatch(_loc3_);
				}
			}

			// Setup each entry that we can display on screen (with regards to size restrictions, and number of list items set in the main controller.)
			while (_loc2_ != int.MAX_VALUE && _loc2_ != -1 && _loc2_ < this.EntriesA.length && this.iListItemsShown < this.uiNumListItems && verticalSpacing <= this.fListHeight) {
				entry = this.GetClipByIndex(this.iListItemsShown);
				if (entry) {
					// Set the text
					this.SetEntry(entry, this.EntriesA[_loc2_]);

					// Set the clip index (list index)
					this.EntriesA[_loc2_].clipIndex = this.iListItemsShown;
					entry.itemIndex = _loc2_;
					entry.visible = !this.needMobileScrollList;
					verticalSpacing = verticalSpacing + entry.height;

					// Add vertical spacing if we need it. (Although the variable is never used?)
					if (verticalSpacing <= this.fListHeight && this.iListItemsShown < this.uiNumListItems) {
						verticalSpacing = verticalSpacing + this.fVerticalSpacing;
						this.iListItemsShown++;
					} else if (this.textOption != TEXT_OPTION_MULTILINE) { // If we're multi-line, default set clip index to MAX INT, and make us not visible
						this.EntriesA[_loc2_].clipIndex = int.MAX_VALUE;
						entry.visible = false;
					} else {
						// Otherwise continue along
						this.iListItemsShown++;
					}
				}

				// Setup the next entry for this loop
				_loc2_ = this._filterer.GetNextFilterMatch(_loc2_);
			}

			// TODO: Mobile only code, so figure it out later!
			if (this.needMobileScrollList) {
				this.setMobileScrollingListData(_loc6_);
			}

			// Re-position all the entries
			this.PositionEntries();

			// Hide the left scroll buttons if we don't need them
			if (this.ScrollUp != null) {
				this.ScrollUp.visible = this.scrollPosition > 0;
			}
			if (this.ScrollDown != null) {
				this.ScrollDown.visible = this.scrollPosition < this.iMaxScrollPosition;
			}

			

			// Hey we updated the list, so do the state-ful way of mucking aboat.
			this.bUpdated = true;
		}

		public function deflatePreviousSelection(entry: InvListEntry): * {
			var previousEntry: InvListEntry;

			if (this.iLastClipIndex != 9999) {
				previousEntry = this.GetClipByIndex(this.iLastClipIndex) as InvListEntry;
			}

			if (previousEntry && entry.clipIndex != this.iLastClipIndex) {
				previousEntry.gotoAndStop("Normal");
				previousEntry.height = 40;
				previousEntry.onDeflate();
			}
		}

		public function expandSelection(entry: InvListEntry): * {
			if (entry.clipIndex != this.iLastClipIndex) {
				entry.gotoAndStop("Expanded");
				entry.height = 120;
				//this.pushEntries(entry);
				this.iLastClipIndex = entry.clipIndex;

			}

			this.doSetSelectedIndex(entry.itemIndex) as InvListEntry;
			this.PositionEntries();
			entry.onExpand();
		}

		public function deflateSelection(entry: InvListEntry): * {
			entry.gotoAndStop("Normal");
			entry.height = 40;
			entry.onDeflate();
			this.PositionEntries();
		}

		/*
		override public function onKeyDown(evt: KeyboardEvent): * {
			super.onKeyDown(evt);
			
			if(this.bDisableInput) {
				return;
			}
			
			var entry: InvListEntry = this.GetClipByIndex(this.selectedClipIndex) as InvListEntry;

			this.deflatePreviousSelection(entry);
			this.expandSelection(entry);
		}
		*/
		/*
		override public function moveSelectionUp(): * {
			super.moveSelectionUp();
			var entry: InvListEntry = this.GetClipByIndex(this.selectedClipIndex) as InvListEntry;
			
			this.deflatePreviousSelection(entry);
			this.expandSelection(entry);
		}

		override public function moveSelectionDown(): * {
			super.moveSelectionDown();

			var entry: InvListEntry = this.GetClipByIndex(this.selectedClipIndex) as InvListEntry;
			this.dispatchEvent(new CustomEvent("Debug::Log", "Got entry" + this.selectedClipIndex, true, true));

			this.deflatePreviousSelection(entry);
			this.expandSelection(entry);
		}
*/
		/**
		 * Override the mouse wheel event, so we reset all entries
		 */
		override public function onMouseWheel(evt: MouseEvent): * {
			/*
			try {
				for (var i: int; i < this.getNumEntries(); i++) {
					var entry = this.GetClipByIndex(i);
					entry.gotoAndStop("Normal");
					entry.height = 40;
				}

				this.PositionEntries();
			} catch (error: Error) {
				this.dispatchEvent(new CustomEvent("Debug::Log", "[onMouseWheel] Error Occured :\n" + error.name + "\n" + error.message, true, true));
			}
			*/

			super.onMouseWheel(evt);
		}


		override protected function PositionEntries(): * {
			var _loc1_: Number = 0;
			var borderY: Number = this.border.y;
			var index: int = 0;
			while (index < this.iListItemsShown) {
				this.GetClipByIndex(index).y = borderY + _loc1_;
				_loc1_ = _loc1_ + (this.GetClipByIndex(index).height + this.fVerticalSpacing);
				index++;
			}
			this.fShownItemsHeight = _loc1_;
		}
	}
}