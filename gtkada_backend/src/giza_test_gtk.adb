with Timer_Callback; use Timer_Callback;
with Giza.Window;
use Giza;
with Screen_Interface; use Screen_Interface;
with Giza.GUI; use Giza.GUI;
--  with Hershey_Fonts.Rowmand;
with Giza.Bitmap_Fonts.FreeMono8pt7b;
with Test_Main_Window; use Test_Main_Window;

procedure Giza_Test_Gtk is
   Main_W : constant Main_Window_Ref := new Main_Window;
   Enable_Backend : constant Boolean := True;
begin

   if Enable_Backend then
      Screen_Interface.Initialize;
   else
      Timer_Callback.My_Backend.Disable;
   end if;

   My_Context.Set_Font (Giza.Bitmap_Fonts.FreeMono8pt7b.Font);
   Giza.GUI.Set_Context (Timer_Callback.My_Context'Access);
   Giza.GUI.Set_Backend (Timer_Callback.My_Backend'Access);

   Push (Window.Ref (Main_W));

   Event_Loop;

end Giza_Test_Gtk;
