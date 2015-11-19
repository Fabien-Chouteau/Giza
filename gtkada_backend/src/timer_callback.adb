with Ada.Text_IO; use Ada.Text_IO;
with Giza.Timers; use Giza.Timers;
with Ada.Real_Time; use Ada.Real_Time;
with Screen_Interface; use Screen_Interface;
with Giza.GUI; use Giza.GUI;
with Engine_Control_Events; use Engine_Control_Events;

package body Timer_Callback is

   Cnt : Integer := 0;

   RPM_Evt : aliased Set_RPM_Event;

   --------------
   -- Callback --
   --------------

   function Callback return Boolean is
   begin
      --  Put_Line ("Here comes the callback:" & Cnt'Img);
      Cnt := Cnt + 1;
      RPM_Evt.RPM := Cnt * 10;
      Emit (RPM_Evt'Access);
      Set_Timer (My_Timer'Unchecked_Access, Clock + Milliseconds (500));
      return True;
   end Callback;

   task Touch_Screen is
   end Touch_Screen;

   task body Touch_Screen is
      TS, Prev : Touch_State;
      Evt : Click_Event_Ref := new Click_Event;
      Released_Evt : Click_Released_Event_Ref := new Click_Released_Event;
   begin
      Prev.Touch_Detected := False;
      loop
         TS := Get_Touch_State;
         if TS.Touch_Detected /= Prev.Touch_Detected then

            if TS.Touch_Detected then
               Evt.Pos.X := TS.X;
               Evt.Pos.Y := TS.Y;
               Emit (Event_Not_Null_Ref (Evt));
            else
               Emit (Event_Not_Null_Ref (Released_Evt));
            end if;
         end if;
         Prev := TS;
      end loop;
   end Touch_Screen;

end Timer_Callback;
