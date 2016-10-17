with Giza.Graphics;
with Giza.Events;         use Giza.Events;
with Giza.Widgets.Text;
with Giza.Widgets.Button;
use Giza.Widgets;

with Screen_Interface; use Screen_Interface;
with Test_Main_Window;

package Timer_Callback is

   Main_W : aliased Test_Main_Window.Main_Window;

   My_Str : access String := new String'("Gtext");
   Str_Button : access String := new String'("Button");
   Str_Toggle : access String := new String'("Toggle");

   My_Txt    : aliased Text.Instance;
   My_Button : aliased Button.Instance;
   My_Toggle : aliased Button.Instance;

   My_Backend : aliased Screen_Interface.GTKada_Backend;
   My_Context : aliased Giza.Graphics.Context;

   function Callback return Boolean;

   My_Timer : aliased Basic_Timer_Event :=
     (Callback => Callback'Access);

end Timer_Callback;
