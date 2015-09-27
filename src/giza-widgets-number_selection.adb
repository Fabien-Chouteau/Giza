package body Giza.Widgets.Number_Selection is

   ---------------
   -- Set_Dirty --
   ---------------

   procedure Set_Dirty (This : in out Gnumber_Select;
                        Dirty : Boolean := True)
   is
   begin
      This.Root.Set_Dirty (Dirty);
   end Set_Dirty;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out Gnumber_Select;
      Ctx : in out Context'Class;
      Force : Boolean := True)
   is
      W1, W2, H1 : Integer;
      Top, Bottom, Left, Right : Integer;
      Pt : Point_T;
      Value_Rect, Lable_Rect : Rect_T;
   begin
      --  0         W1                                          W2        W
      --  +---------+-------------------------------------------+---------+
      --  |                                                               |
      --  |                             Value                             |
      --  |                                                               |
      --  +---------+-------------------------------------------+---------+ H1
      --  |         |                                           |    |    |
      --  |  -----  |                   Label                   |  -----  |
      --  |         |                                           |    |    |
      --  +---------+-------------------------------------------+---------+

      H1 := (if This.Show_Value then This.Get_Size.H / 2 else 0);
      W1 := This.Get_Size.H - H1;
      W2 := This.Get_Size.W - W1;

      Lable_Rect := ((W1 + 1, H1),
                     (W2 - W1 - 2, W1));

      if not This.Init then
         This.Init := True;

         This.Root.Set_Size (This.Get_Size);

         This.Minus := new Gbutton;
         This.Minus.Set_Text ("-");
         This.Minus.Set_Size ((W1, W1));
         This.Root.Add_Child (This.Minus, (0, H1));

         This.Plus := new Gbutton;
         This.Plus.Set_Text ("+");
         This.Plus.Set_Size ((W1, W1));
         This.Root.Add_Child (This.Plus, (W2, H1));
      end if;

      if This.Dirty or else Force then
         if This.Show_Value then
            Value_Rect := ((0, 0), (This.Get_Size.W, H1 - 1));
            declare
               Str : constant String := This.Value'Img;
            begin
               Ctx.Set_Color (This.Background);
               Ctx.Fill_Rectangle (Value_Rect);

               Ctx.Set_Color (This.Foreground);
               Pt := Center (Value_Rect);
               Ctx.Box (Str, Top, Bottom, Left, Right);
               Pt.X := Pt.X - (Right - Left) / 2;
               Ctx.Move_To (Pt);
               Ctx.Print (Str);
            end;
         end if;

         if This.Str /= null then
            Ctx.Set_Color (This.Background);
            Ctx.Fill_Rectangle (Lable_Rect);

            Ctx.Set_Color (This.Foreground);
            Pt := Center (Lable_Rect);
            Ctx.Box (This.Str.all, Top, Bottom, Left, Right);
            Pt.X := Pt.X - (Right - Left) / 2;
            Ctx.Move_To (Pt);
            Ctx.Print (This.Str.all);
         end if;
      end if;
      This.Root.Draw (Ctx, Force);
   end Draw;

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

   ----------------
   -- Show_Value --
   ----------------

   procedure Show_Value (This : in out Gnumber_Select;
                         Show : Boolean := True)
   is
   begin
      This.Show_Value := Show;
   end Show_Value;

end Giza.Widgets.Number_Selection;
