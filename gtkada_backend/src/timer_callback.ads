with Giza.Events; use Giza.Events;
with Giza.Widgets.Text; use Giza.Widgets.Text;
with Giza.Widgets.Button; use Giza.Widgets.Button;
with Screen_Interface; use Screen_Interface;
with Giza.Graphics;
with Engine_Control_UI; use Engine_Control_UI;

package Timer_Callback is

   ECW : aliased Engine_Control_Window;

   My_Str : access string := new String'("Gtext");
   Str_Button : access string := new String'("Button");
   Str_Toggle : access string := new String'("Toggle");

   My_Txt : aliased Gtext;
   My_Button : aliased Gbutton;
   My_Toggle : aliased Gbutton;

   My_Backend : aliased Screen_Interface.GTKada_Backend;
   My_Context : aliased Giza.Graphics.Context;

   procedure Callback;

   My_Timer : aliased Basic_Timer_Event :=
     (Callback => Callback'Access);

end Timer_Callback;
