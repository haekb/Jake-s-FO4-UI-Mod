package {
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.events.Event;
	import Shared.CustomEvent;
	import flash.utils.getQualifiedClassName;
	import Shared.GlobalFunc;
	
	public class InvListEntry extends BSScrollingListEntry {
		public static const INV_LIST_ENTRY_UPDATE = "InvListEntry::Update";

		private var _prefText: String;

		public var currentTab: uint = 0;
		
		// Stores ItemCard info!
		public var infoObj: Array;

		// Store some top stats for cool dudes and also sorting
		public var damageStats: int;
		public var fireRateStats: int;
		public var rangeStats: int;
		public var accuracyStats: int;
		public var weightStats: int;
		public var valueStats: int;

		public var descriptionField: TextField;

		// Info Boxes
		public var infoBox1: TextField;
		public var infoBox2: TextField;
		public var infoBox3: TextField;
		public var infoBox4: TextField;
		public var infoBox5: TextField;
		public var infoBox6: TextField;
		public var infoBox7: TextField;
		public var infoBox8: TextField;
		public var infoBox9: TextField;
		public var infoBox10: TextField;

		public var isExpanded: Boolean;

		public var Outline1: MovieClip;
		public var Outline2: MovieClip;

		// Icons
		public var EquipIcon_mc: MovieClip;
		public var FavIcon_mc: MovieClip;
		public var LegendaryIcon_mc: MovieClip;
		public var SearchIcon_mc: MovieClip;

		private var BaseTextFieldWidth:*;

		// Colours!
		private const SelectedColorTransform: ColorTransform = new ColorTransform(1, 1, 1, 1, -255, -255, -255, 0);
		private const UnselectedColorTransform: ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		private const outlineColorTransform: ColorTransform = new ColorTransform(1, 1, 1, 1, -128, 128, 128, 0);

		public function InvListEntry() {
			addFrameScript(0, this.frameNormal, 1, this.frameExpanded);

			this.isExpanded = false;
			this.infoObj = new Array();
			
			this.damageStats    = 0;
			this.fireRateStats = 0;
			this.rangeStats = 0;
			this.accuracyStats = 0;
			this.weightStats  = 0;
			this.valueStats = 0;

			super();
			//this.setFrame("singleEntry");
			this.BaseTextFieldWidth = textField.width;

		}
		public function reBindClips() {

			// If we're expanded, we want to grab the other border
			if (this.isExpanded) {
				this.border = this.getChildByName("borderExp") as MovieClip;

				this.Outline2 = this.getChildByName("Outline2") as MovieClip;

				// These info boxes are only available in expanded view
				this.infoBox7 = this.getChildByName("infoBox7") as TextField;
				this.infoBox8 = this.getChildByName("infoBox8") as TextField;
				this.infoBox9 = this.getChildByName("infoBox9") as TextField;
				this.infoBox10 = this.getChildByName("infoBox10") as TextField;

				// Also only available in expanded view
				this.descriptionField = this.getChildByName("descriptionField") as TextField;
			} else {
				this.border = this.getChildByName("border") as MovieClip;

				this.Outline1 = this.getChildByName("Outline1") as MovieClip;

				// These fields aren't available;
				this.descriptionField = null;
				this.infoBox7 = null;
				this.infoBox8 = null;
				this.infoBox9 = null;
				this.infoBox10 = null;
			}

			this.infoBox1 = this.getChildByName("infoBox1") as TextField;
			this.infoBox2 = this.getChildByName("infoBox2") as TextField;
			this.infoBox3 = this.getChildByName("infoBox3") as TextField;
			this.infoBox4 = this.getChildByName("infoBox4") as TextField;
			this.infoBox5 = this.getChildByName("infoBox5") as TextField;
			this.infoBox6 = this.getChildByName("infoBox6") as TextField;

			this.textField = this.getChildByName("textField") as TextField;

			if (this.Outline1 != null) {
				this.Outline1.transform.colorTransform = this.outlineColorTransform;
			}
			if (this.Outline2 != null) {
				this.Outline2.transform.colorTransform = this.outlineColorTransform;
			}

			this.ORIG_BORDER_HEIGHT = this.border != null ? Number(this.border.height) : Number(0);

			this.dispatchEvent(new CustomEvent("Debug::Log", "Desc? " + (this.descriptionField == null), true, true));
		}

		/*
		 * Stop animation from autoplaying
		 */
		public function frameNormal() : * {
			stop();
		}

		public function frameExpanded() : * {
			stop();
		}

		/**
		 * Gets called when the player selects another list item
		 */
		public function onDeflate() : * {
			this.isExpanded = false;
			this.reBindClips();
			this.border.alpha = Number(0);
		}

		/**
		 * Gets called when a player selects this list item
		 */
		public function onExpand() : * {
			// this function gets called too soon i think???
			if (this.infoObj == null) {
				return;
			}

			this.isExpanded = true;
			this.reBindClips();

			this.dispatchEvent(new CustomEvent("Debug::Log", "Running Expanded Animation Function! Am I selected?" + this.selected, true, true));

			try {
				trace(this.selected);

				var contextColour: ColorTransform = !! this.selected ? this.SelectedColorTransform : this.UnselectedColorTransform;

				this.infoBox1.transform.colorTransform = contextColour;
				this.infoBox2.transform.colorTransform = contextColour;
				this.infoBox3.transform.colorTransform = contextColour;
				this.infoBox4.transform.colorTransform = contextColour;
				this.infoBox5.transform.colorTransform = contextColour;
				this.infoBox6.transform.colorTransform = contextColour;
				this.infoBox7.transform.colorTransform = contextColour;
				this.infoBox8.transform.colorTransform = contextColour;
				this.infoBox9.transform.colorTransform = contextColour;
				this.infoBox10.transform.colorTransform = contextColour;

				// Set the highlight colour
				if (this.descriptionField != null) {
					this.dispatchEvent(new CustomEvent("Debug::Log", "Found description!", true, true));
					this.descriptionField.transform.colorTransform = contextColour;
				}

				this.border.alpha = Number(GlobalFunc.SELECTED_RECT_ALPHA);
				this.updateInfoText();
			} catch (error: Error) {
				trace( "[onExpand] Error expanding " + error.name + "\n" + error.message);
				this.dispatchEvent(new CustomEvent("Debug::Log", "[onExpand] Error expanding " + error.name + "\n" + error.message, true, true));
			}


		}

		public function Poke(): * {
			this._prefText = "HANNAH IS COOL";

		}


		override public function SetEntryText(item: Object, itemText: String): * {
			this.dispatchEvent(new CustomEvent("Debug::Log", "Setting Entry Text!", true, true));
			var iIconWidth: int = 0;
			var fIconApplied: Boolean = false;
			var oTextFormat: TextFormat = null;
			if (this.LegendaryIcon_mc != null) {
				this.LegendaryIcon_mc.visible = item.isLegendary;
				fIconApplied = true;
			}
			if (this.FavIcon_mc != null) {
				this.FavIcon_mc.visible = item.favorite > 0;
				if (fIconApplied) {
					iIconWidth = iIconWidth + (this.FavIcon_mc.width / 2 + 10);
				}
				fIconApplied = true;
			}
			if (this.SearchIcon_mc != null) {
				this.SearchIcon_mc.visible = item.taggedForSearch;
				if (fIconApplied) {
					iIconWidth = iIconWidth + (this.SearchIcon_mc.width / 2 + 10);
				}
			}
			textField.width = this.BaseTextFieldWidth - iIconWidth;

			//super.SetEntryText(item, itemText);

			GlobalFunc.SetText(this.textField, item.text, true);

			if (item.count != 1) {
				textField.appendText(" (" + item.count + ")");
			}

			var _loc5_: Number = this.textField.getLineMetrics(0).width + this.textField.x + 15;
			//trace("Selected? "+this.selected);
			var contextColour: ColorTransform = !! this.selected ? this.SelectedColorTransform : this.UnselectedColorTransform;

			this.textField.transform.colorTransform = contextColour;

			if (this.EquipIcon_mc != null) {
				this.EquipIcon_mc.visible = item.equipState > 0;
				if (this.EquipIcon_mc.visible) {
					this.EquipIcon_mc.transform.colorTransform = contextColour;
				}
			}
			if (this.LegendaryIcon_mc != null && this.LegendaryIcon_mc.visible) {
				this.LegendaryIcon_mc.x = _loc5_;
				_loc5_ = _loc5_ + (this.LegendaryIcon_mc.width / 2 + 10);
				this.LegendaryIcon_mc.transform.colorTransform = contextColour;
			}
			if (this.FavIcon_mc != null && this.FavIcon_mc.visible) {
				this.FavIcon_mc.x = _loc5_;
				_loc5_ = _loc5_ + (this.FavIcon_mc.width / 2 + 10);
				this.FavIcon_mc.transform.colorTransform = contextColour;
			}
			if (this.SearchIcon_mc != null && this.SearchIcon_mc.visible) {
				this.SearchIcon_mc.x = _loc5_;
				this.SearchIcon_mc.transform.colorTransform = contextColour;
			}
		}

		public function updateInfoText(): * {
			if (this.infoObj != null && this.infoObj.length > 0) {

				var index: int = 1;

				// Clear out the boxes first
				this.infoBox1.text = "";
				this.infoBox2.text = "";
				this.infoBox3.text = "";
				this.infoBox4.text = "";
				this.infoBox5.text = "";
				this.infoBox6.text = "";

				if (this.isExpanded) {
					this.infoBox7.text = "";
					this.infoBox8.text = "";
					this.infoBox9.text = "";
					this.infoBox10.text = "";
				}

				// So we can have a nice almost equal sort!
				var weights = {
					"$dmg": 0,
					"$dr": 0,
					"$ROF": 1,
					"$speed": 1,
					"$rng": 2,
					"$acc": 3,
					"$wt": 4,
					"$val": 5,
					"default": 9
				};

				// For expanded entry, we want to dynamically fill in these values
				if (this.isExpanded) {
					try {

						var formattedValues = [];
						//var keyIncrementals = [];

						for each(var info in this.infoObj) {
							var output: * = null;
							var numValue: Number = NaN;
							var precision: uint = 0;
							var isFloat: * = undefined;

							var gotToSet: Boolean = false;

							if (info.value == 0) {
								continue;
							}

							if (info.value is String) {
								output = info.value;
							} else {
								numValue = info.value;

								if (info.scaleWithDuration) {
									numValue = numValue * info.duration;
								}
								output = numValue.toString();
								precision = info.precision != undefined ? uint(info.precision) : uint(0);
								isFloat = output.indexOf(".");
								if (isFloat > -1) {
									if (precision) {
										output = output.substring(0, Math.min(isFloat + precision + 1, output.length));
									} else {
										output = output.substring(0, isFloat);
									}
								}
								if (info.showAsPercent) {
									output = output + "%";
								}
							}
							gotToSet = true;

							var key:String = info.text;
							var weight:int = weights['default'];
							
							if(weights.hasOwnProperty(key)) {
								weight = weights[key];
							}
							formattedValues.push({"weight": weight, "key": key, "value": this.localize(info.text) + "\n" + this.localize(output)});
						}

						// Sort the list!
						formattedValues.sortOn(["weight", "key"] , [ Array.NUMERIC | Array.DESCENDING ]);

						// Set the values, and eventually icons
						for(index=1; index < 11; index++)
						{
							var iMinusOne = index - 1;
							this["infoBox" + index].text = formattedValues[iMinusOne].value;
						}						



					} catch (error: Error) {
						this.dispatchEvent(new CustomEvent("Debug::Log", "Error running expanded info getter!\n" + error.name + "\n" + error.message + "\n On iteration " + index + "\nDid I get to setter? " + gotToSet, true, true));
					}
				} else {
					var infoBoxData: Array = [];

					if (this.currentTab == 0) {
						infoBoxData = [
							this.getInfoOf("value", "$dmg", true),
							this.getInfoOf("value", "$ROF"),
							this.getInfoOf("value", "$rng"),
							this.getInfoOf("value", "$acc"),
							this.getInfoOf("value", "$wt"),
							this.getInfoOf("value", "$val")
						];
					} else if (this.currentTab == 1) {

						infoBoxData = [
							this.getInfoOf("value", "$dr", true),
							this.getInfoOf("value", "", false, ""),
							this.getInfoOf("value", "", false, ""),
							this.getInfoOf("value", "", false, ""),
							this.getInfoOf("value", "$wt"),
							this.getInfoOf("value", "$val"),
						];
					} else {
						infoBoxData = [
							this.getInfoOf("value", "", false, ""),
							this.getInfoOf("value", "", false, ""),
							this.getInfoOf("value", "", false, ""),
							this.getInfoOf("value", "", false, ""),
							this.getInfoOf("value", "$wt"),
							this.getInfoOf("value", "$val"),
						];
					}
					

					this.damageStats    = infoBoxData[0];
					this.fireRateStats = infoBoxData[1];
					this.rangeStats = infoBoxData[2];
					this.accuracyStats = infoBoxData[3];
					this.weightStats  = infoBoxData[4];
					this.valueStats = infoBoxData[5];
					//trace(infoBoxData);

					//trace("Damage set to "+this.damageStats);

					//this.dispatchEvent(new CustomEvent("Debug::LogObject", this.infoObj, true, true));

					// Ok now that we're all good here, set the text boxes and icons!
					index = 0;

					for (index = 1; index < 7; index++) {
						var textData:String = "";
						var oneMinus:* = index - 1;

						if(infoBoxData[oneMinus] == null) {
							this.dispatchEvent(new CustomEvent("Debug::Log", "["+oneMinus+"] Is null...for some reason", true, true));
						}
						
						// If it's a string, then just return the string.
						if(!infoBoxData[oneMinus].hasOwnProperty("value")) {
							this.dispatchEvent(new CustomEvent("Debug::Log", "["+oneMinus+"] Text Data Detected", true, true));

							textData = infoBoxData[oneMinus];
						} else { // Otherwise run it through mr.format.
							this.dispatchEvent(new CustomEvent("Debug::Log", "["+oneMinus+"] Object Data Detected", true, true));

							textData = format(infoBoxData[oneMinus]);
						}

						this.dispatchEvent(new CustomEvent("Debug::Log", "["+oneMinus+"] textData Variable is set to "+textData, true, true));


						this["infoBox" + index].text = textData;

						// TODO: Set icons!
					}
				}

				if (this.descriptionField != null) {
					this.descriptionField.text = this.getInfoOf("description", true);
				}
			} else {
				this.infoBox1.text = "TOUCHED BUT NOT SET";
			}
		}

		private function localize(token: String): String {
			var map: Object = {
				"$dmg": "Damage",
				"$dr": "Resistance",
				"$ROF": "ROF", // Rate of Fire (Won't fit bro)
				"$rng": "Range",
				"$acc": "Accuracy",
				"$wt": "Weight",
				"$val": "Value",
				"$speed": "Speed",
				"$SLOW": "Slow",
				"$MEDIUM": "Medium",
				"$FAST": "Fast",
				"$health": "HP"
			};

			// If we have the localized string available, then return that
			if (map.hasOwnProperty(token)) {
				return map[token];
			}

			// Fallback to just the token
			return token;
		}

		private function getInfoOf(field: String, value: * , combineAllMatches: Boolean = false, defaultReturn: String = "N/A"): * {
			var scope: Object = new Object();
			scope.testValue = value;
			scope.field = field;

			var filterFunction: Function = function (element: * , index: int, arr: Array): Boolean {

				if (this.field == "value" || this.field == "text") {
					return (element.text == this.testValue && element.value != null && element.value > 0);
				} else if (this.field == "description") {
					return (element.showAsDescription == this.testValue && element.text != null);
				}

				return false;
			}

			var items: Array;

			try {
				items = this.infoObj.filter(filterFunction, scope);
			} catch (error: Error) {
				this.dispatchEvent(new CustomEvent("Debug::Log", "Error running filter!" + error.name + "\n" + error.message, true, true));
			}


			if (items == null || items.length == 0) {
				return defaultReturn;
			}

			if (items.length > 1 && combineAllMatches) {
				this.dispatchEvent(new CustomEvent("Debug::Log", "Found a combine match! For "+field+ " | value "+value, true, true));
			}

			if (field == "description" || field == "text") {
				return items[0].text;
			}

			if (combineAllMatches) {
				var skipIteration:Boolean = true;
				for each(var itemValue:* in items) {
					// Skip the first one
					if (skipIteration) {
						skipIteration = true;
						continue;
					}

					// Skip any zero values
					if (itemValue.value <= 0) {
						continue;
					}

					items[0].value += itemValue.value;
				}
			}

			return items[0];
			//return format(items[0]);
		}

		/**
		 * From ItemCard_Entry
		 */
		private function format(item: Object): * {
			var output: * = null;
			var value: Number = NaN;
			var precision: uint = 0;
			var isFloat: * = undefined;

			value = item.value;
			if (item.scaleWithDuration) {
				value = value * item.duration;
			}
			output = value.toString();
			precision = item.precision != undefined ? uint(item.precision) : uint(0);
			isFloat = output.indexOf(".");
			if (isFloat > -1) {
				if (precision) {
					output = output.substring(0, Math.min(isFloat + precision + 1, output.length));
				} else {
					output = output.substring(0, isFloat);
				}
			}
			if (item.showAsPercent) {
				output = output + "%";
			}

			return output;
		}
	}
}