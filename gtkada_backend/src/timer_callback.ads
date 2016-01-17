with Giza.Events; use Giza.Events;
with Giza.Widgets.Text; use Giza.Widgets.Text;
with Giza.Widgets.Button; use Giza.Widgets.Button;
with Screen_Interface; use Screen_Interface;
with Giza.Graphics;
with Question_Windows; use Question_Windows;

package Timer_Callback is

   Main_W : aliased Question_Window;

   My_Str : access String := new String'("Gtext");
   Str_Button : access String := new String'("Button");
   Str_Toggle : access String := new String'("Toggle");

   My_Txt : aliased Gtext;
   My_Button : aliased Gbutton;
   My_Toggle : aliased Gbutton;

   My_Backend : aliased Screen_Interface.GTKada_Backend;
   My_Context : aliased Giza.Graphics.Context;

   function Callback return Boolean;

   My_Timer : aliased Basic_Timer_Event :=
     (Callback => Callback'Access);

end Timer_Callback;
