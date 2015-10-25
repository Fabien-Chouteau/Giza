with Ada.Text_IO; use Ada.Text_IO;
with Giza.Timers; use Giza.Timers;
with Ada.Real_Time; use Ada.Real_Time;
with Screen_Interface; use Screen_Interface;
with Giza.GUI; use Giza.GUI;

package body Timer_Callback is

   Cnt : Integer := 0;

   --------------
   -- Callback --
   --------------

   procedure Callback is
   begin
      Put_Line ("Here comes the callback:" & Cnt'Img);
      Cnt := Cnt + 1;
      Set_Timer (My_Timer'Unchecked_Access, Clock + Milliseconds (500));
   end Callback;

   task Touch_Screen is
   end Touch_Screen;

   task body Touch_Screen is
      TS, Prev : Touch_State;
      Evt : constant access Click_Event := new Click_Event;
   begin
      Prev.Touch_Detected := False;
      loop
         TS := Get_Touch_State;
         if TS.Touch_Detected /= Prev.Touch_Detected then

            Evt.Pos.X := TS.X;
            Evt.Pos.Y := TS.Y;
            if TS.Touch_Detected then
               Evt.CType := Click_Press;
            else
               Evt.CType := Click_Release;
            end if;
            Emit (Evt);
         end if;
         Prev := TS;
      end loop;
   end Touch_Screen;

end Timer_Callback;
