with Timer_Callback;
use Timer_Callback;
with Giza.Windows; use Giza.Windows;
with Screen_Interface; use Screen_Interface;
with Giza.Widgets.Text; use Giza.Widgets.Text;
with Giza.GUI; use Giza.GUI;
with Giza.Colors; use Giza.Colors;
with Giza.Graphics;
with Hershey_Fonts.Rowmand;
with Test_Main_Window; use Test_Main_Window;

procedure Giza_Test_Gtk is
   Main_W : Main_Window_Ref := new Main_Window;
begin

   Screen_Interface.Initialize;

   My_Context.Set_Font (Hershey_Fonts.Rowmand.Font);
   Giza.GUI.Set_Context (Timer_Callback.My_Context'Access);
   Giza.GUI.Set_Backend (Timer_Callback.My_Backend'Access);

   Push (Window_Ref (Main_W));

   Event_Loop;

end Giza_Test_Gtk;
