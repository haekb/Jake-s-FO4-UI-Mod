package Shared
{
   import flash.external.ExternalInterface;
   import Shared.AS3.COMPANIONAPP.CompanionAppMode;
   
   public class BGSExternalInterface
   {
       
      
      public function BGSExternalInterface()
      {
         super();
      }

      public static function call(param1:Object, ... rest) : void
      {
         var _loc3_:String = null;
         var _loc4_:Function = null;

         if(CompanionAppMode.isOn)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call.apply(null,rest);
            }
            else
            {
               trace("BGSExternalInterface::call -- ExternalInterface is not available!");
            }
            return;
         }
         if(param1 != null)
         {

            /* Param1 has the available functions (stubs?)
            [PlaySound] -> function Function() {}
            [ToggleRadioStationActiveStatus] -> function Function() {}
            [ShowPerksMenu] -> function Function() {}
            [onNewPage] -> function Function() {}
            [ToggleComponentFavorite] -> function Function() {}
            [SetQuestActive] -> function Function() {}
            [PlayPerkSound] -> function Function() {}
            [onSwitchBetweenWorldLocalMap] -> function Function() {}
            [onShowHotKeys] -> function Function() {}
            [onPerksTabOpen] -> function Function() {}
            [onModalOpen] -> function Function() {}
            [CheckHardcoreModeFastTravel] -> function Function() {}
            [CenterMarkerRequest] -> function Function() {}
            [ShowWorkshopOnMap] -> function Function() {}
            [UseStimpak] -> function Function() {}
            [onInvItemSelection] -> function Function() {}
            [HasSetPlayerMarkerRequest] -> function Function() {}
            [onQuestSelection] -> function Function() {}
            [ExamineItem] -> function Function() {}
            [toggleMovementToDirectional] -> function Function() {}
            [SortItemList] -> function Function() {}
            [UnregisterMap] -> function Function() {}
            [ClearPlayerMarker] -> function Function() {}
            [onNewTab] -> function Function() {}
            [RegisterMap] -> function Function() {}
            [PlaySmallTransition] -> function Function() {}
            [StopPerkSound] -> function Function() {}
            [onComponentViewToggle] -> function Function() {}
            [RefreshMapMarkers] -> function Function() {}
            [SetPlayerMarker] -> function Function() {}
            [PopulatePipboyInfoObj] -> function Function() {}
            [SelectItem] -> function Function() {}
            [ItemDrop] -> function Function() {}
            [onPerksTabClose] -> function Function() {}
            [updateItem3D] -> function Function() {}
            [SetQuickkey] -> function Function() {}
            [FastTravel] -> function Function() {}
            [ShowQuestOnMap] -> function Function() {}
            [UseRadaway] -> function Function() {}
            */

            _loc3_ = rest.shift();
            _loc4_ = param1[_loc3_];
            if(_loc4_ != null)
            {
               _loc4_.apply(null,rest);
            }
            else
            {
               trace("BGSExternalInterface::call -- Can\'t call function \'" + _loc3_ + "\' on BGSCodeObj. This function doesn\'t exist!");
            }
         }
         else
         {
            trace("BGSExternalInterface::call -- Can\'t call function \'" + _loc3_ + "\' on BGSCodeObj. BGSCodeObj is null!");
         }
      }
   }
}
