with Giza.Timers; use Giza.Timers;
with Ada.Real_Time; use Ada.Real_Time;
with Timer_Callback;
use Timer_Callback;
with Giza.Windows; use Giza.Windows;
with Screen_Interface; use Screen_Interface;
with Giza.Widgets.Text; use Giza.Widgets.Text;
with Giza.GUI; use Giza.GUI;
with Giza.Colors; use Giza.Colors;
with Giza.Graphics;

procedure Main is
   Main_W : constant Window_Ref := Create;
begin

   Screen_Interface.Initialize;

   Giza.GUI.Set_Context (Timer_Callback.My_Context'Access);
   Giza.GUI.Set_Backend (Timer_Callback.My_Backend'Access);

   My_Txt.Set_Foreground (Red);
   My_Txt.Set_Background (Forest_Green);
   My_Txt.Set_Size ((50, 50));
   My_Txt.Set_Text (Timer_Callback.My_Str);

   My_Button.Set_Foreground (Black);
   My_Button.Set_Background (White);
   My_Button.Set_Size ((50, 50));
   My_Button.Set_Text (Timer_Callback.Str_Button);
   My_Button.Set_Toggle (False);

   My_Toggle.Set_Foreground (Medium_Orchid);
   My_Toggle.Set_Background (White);
   My_Toggle.Set_Size ((50, 50));
   My_Toggle.Set_Text (Timer_Callback.Str_Toggle);
   My_Toggle.Set_Toggle (True);

   Main_W.Set_Size ((100, 100));
   Main_W.Add_Child (My_Txt'Access, (0, 0));
   Main_W.Add_Child (My_Button'Access, (0, 50));
   Main_W.Add_Child (My_Toggle'Access, (50, 0));
   Push (Main_W);
   Push (ECW);

   Set_Timer (Timer_Callback.My_Timer'Access, Clock + Seconds (2));


   Event_Loop;

end Main;
