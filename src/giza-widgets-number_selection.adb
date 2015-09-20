with Ada.Text_IO; use Ada.Text_IO;
package body Giza.Widgets.Number_Selection is

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out Gnumber_Select;
      Ctx : in out Context'Class;
      Force : Boolean := True)
   is
      L1, L2 : Integer;
      Top, Bottom, Left, Right : Integer;
      Pt : Point_T;
   begin
      if not This.Init then
         This.Init := True;

         This.Root.Set_Size (This.Get_Size);

         --  0         L1                                          L2        W
         --  +---------+-------------------------------------------+---------+
         --  |         |                                           |         |
         --  |         |                                           |    |    |
         --  |  -----  |                 Label                     |  -----  |
         --  |         |                                           |    |    |
         --  |         |                                           |         |
         --  +---------+-------------------------------------------+---------+

         L1 := This.Get_Size.H;
         L2 := This.Get_Size.W - L1;

         This.Minus := new Gbutton;
         This.Minus.Set_Text ("-");
         This.Minus.Set_Size ((L1, L1));
         This.Root.Add_Child (This.Minus, (0, 0));

         This.Plus := new Gbutton;
         This.Plus.Set_Text ("+");
         This.Plus.Set_Size ((L1, L1));
         This.Root.Add_Child (This.Plus, (L2, 0));
      end if;

      if This.Dirty or else Force then
         if This.Str /= null then
            Pt := Center (((0, 0), This.Get_Size));
            Ctx.Box (This.Str.all, Top, Bottom, Left, Right);
            Pt.X := Pt.X - (Right - Left) / 2;
            Ctx.Move_To (Pt);
            Ctx.Print (This.Str.all);
         end if;
      end if;
      This.Root.Draw (Ctx, Force);
   end Draw;

   -----------
   -- Dirty --
   -----------

   overriding
   function Dirty (This : Gnumber_Select) return Boolean is
      pragma Unreferenced (This);
   begin
      return True;
--        return This.Root.Dirty;
   end Dirty;

   --------------
   -- On_Click --
   --------------

   overriding function On_Click
     (This  : in out Gnumber_Select;
      Pos   : Point_T;
      CType : Click_Type) return Boolean
   is
   begin
      if This.Root.On_Click (Pos, CType) then
         if This.Plus /= null and then This.Plus.Active then
            This.Value := This.Value + This.Step;
            if This.Value > This.Max then
               This.Value := This.Max;
            end if;
         elsif This.Minus /= null and then This.Minus.Active then
            This.Value := This.Value - This.Step;
            if This.Value < This.Min then
               This.Value := This.Min;
            end if;
         end if;
         if This.Str /= null then
            Put_Line (This.Str.all & ".Value :" & This.Value'Img);
         end if;
         return True;
      else
         return False;
      end if;
   end On_Click;

   ---------------
   -- Set_Value --
   ---------------

   procedure Set_Value (This : in out Gnumber_Select; Val : Integer) is
   begin
      This.Value := Val;
      This.Set_Dirty;
   end Set_Value;

   --------------
   -- Set_Step --
   --------------

   procedure Set_Step (This : in out Gnumber_Select; Step : Integer) is
   begin
      This.Step := Step;
   end Set_Step;

   -------------
   -- Set_Min --
   -------------

   procedure Set_Min (This : in out Gnumber_Select; Min : Integer) is
   begin
      This.Min := Min;
   end Set_Min;

   -------------
   -- Set_Max --
   -------------

   procedure Set_Max (This : in out Gnumber_Select; Max : Integer) is
   begin
      This.Max := Max;
   end Set_Max;

   -----------
   -- Value --
   -----------

   function Value (This : Gnumber_Select) return Integer is
   begin
      return This.Value;
   end Value;

   ---------------
   -- Set_Label --
   ---------------

   procedure Set_Label (This : in out Gnumber_Select; Label : String) is
   begin
      This.Str := new String'(Label);
   end Set_Label;

end Giza.Widgets.Number_Selection;
