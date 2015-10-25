package body Power_Phase_Widget is

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
   begin
      if not This.Dirty and then not Force then
         return;
      end if;

      Draw (Gframe (This), Ctx, True);

      Ctx.Set_Color (This.Foreground);

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
   end Draw;

   ------------------
   -- Set_Ignition --
   ------------------

   procedure Set_Ignition
     (This : in out PP_Widget;
      Val : PP_Range)
   is
   begin
      This.Ignition := Val;
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
   end Set_Duration;

end Power_Phase_Widget;
