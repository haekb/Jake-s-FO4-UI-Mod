package Pipboy_InvPage_fla
{
   import flash.display.MovieClip;
   
   public dynamic class GasMask_Anim_21 extends MovieClip
   {
       
      
      public function GasMask_Anim_21()
      {
         super();
         addFrameScript(0,this.frame1,24,this.frame25);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame25() : *
      {
         gotoAndPlay("Animate");
      }
   }
}
