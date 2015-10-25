package body RPM_Widget is

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out RPM;
      Ctx : in out Context'Class;
      Force : Boolean := True)
   is
      Str : constant String := "RPM:" & This.Value'Img;
      Top, Bottom, Left, Right : Integer;
      Pt : Point_T;
   begin
      if not This.Dirty and then not Force then
         return;
      end if;

      Draw (Gframe (This), Ctx, True);

      Ctx.Set_Color (This.Foreground);
      Pt := Center (((0, 0), This.Get_Size));
      Ctx.Box (Str, Top, Bottom, Left, Right);
      Pt.X := Pt.X - (Right - Left) / 2;
      Ctx.Move_To (Pt);
      Ctx.Print (Str);
   end Draw;

   -------------
   -- Set_RPM --
   -------------

   procedure Set_RPM (This : in out RPM; Val : RPM_Range) is
   begin
      This.Value := Val;
      This.Set_Dirty;
   end Set_RPM;

   -------------
   -- Get_RPM --
   -------------

   function Get_RPM (This : RPM) return RPM_Range is
   begin
      return This.Value;
   end Get_RPM;

end RPM_Widget;
