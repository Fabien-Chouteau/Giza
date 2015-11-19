with Ada.Numerics.Generic_Elementary_Functions;
with Giza.Colors; use Giza.Colors;
with Ada.Text_IO; use Ada.Text_IO;
with Engine_Control_Events; use Engine_Control_Events;

package body Power_Phase_Widget is

   package Float_Functions is new
     Ada.Numerics.Generic_Elementary_Functions (Float);
   use Float_Functions;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out PP_Widget;
      Ctx : in out Context'Class;
      Force : Boolean := True)
   is
      Pt : Point_T;

      Radius : Integer;

      Angle : Float;
      From, To : Float;
   begin
      if not This.Dirty and then not Force then
         return;
      end if;

      Draw (Gframe (This), Ctx, True);

      Ctx.Set_Color (Black);

      Pt := Center (((0, 0), This.Get_Size));

      Radius := (if This.Get_Size.H > This.Get_Size.W then
                    This.Get_Size.W
                 else
                    This.Get_Size.H) / 2;

      --  remove a margin
      Radius := Radius - (Radius / 6);

      Ctx.Set_Font_Size (0.5);

      Ctx.Move_To (Pt + (Radius / 2, -Radius));
      Ctx.Print ("- TDC");
      Ctx.Move_To (Pt + (Radius / 2, Radius));
      Ctx.Print ("- BDC");
      Ctx.Circle (Pt, Radius);

      Ctx.Set_Color (Red);

      Angle := Ada.Numerics.Pi / 2.0;
      From := Angle + (Float (This.Ignition) / 100.0) * Ada.Numerics.Pi;
      To := From + Float (This.Duration) / 100.0 * Ada.Numerics.Pi;

      Put_Line ("From angle:" & From'Img);
      Put_Line ("To angle:" & To'Img);
      Ctx.Fill_Arc (Pt, Radius, From, To);

   end Draw;

   --------------
   -- On_Event --
   --------------

   function On_Event
     (This : in out PP_Widget;
      Evt  : Event_Not_Null_Ref) return Boolean
   is
   begin
      if Evt.all in Set_PP_Event'Class then
         declare
            Set_Pulse_Evt : Set_PP_Event_Ref :=
              Set_PP_Event_Ref (Evt);
         begin
            if Set_Pulse_Evt.Ignition < PP_Range'First then
               This.Ignition := PP_Range'First;
            elsif Set_Pulse_Evt.Ignition > PP_Range'Last then
               This.Ignition := PP_Range'Last;
            else
               This.Ignition := Set_Pulse_Evt.Ignition;
            end if;

            if Set_Pulse_Evt.Duration < PP_Range'First then
               This.Duration := PP_Range'First;
            elsif Set_Pulse_Evt.Duration > PP_Range'Last then
               This.Duration := PP_Range'Last;
            else
               This.Duration := Set_Pulse_Evt.Duration;
            end if;
            This.Set_Dirty;
            return True;
         end;
      end if;
      return False;   end On_Event;

   ------------------
   -- Set_Ignition --
   ------------------

   procedure Set_Ignition
     (This : in out PP_Widget;
      Val : PP_Range)
   is
   begin
      This.Ignition := Val;
      This.Set_Dirty;
   end Set_Ignition;

   ------------------
   -- Set_Duration --
   ------------------

   procedure Set_Duration
     (This : in out PP_Widget;
      Val : PP_Range)
   is
   begin
      This.Duration := Val;
      This.Set_Dirty;
   end Set_Duration;

end Power_Phase_Widget;
