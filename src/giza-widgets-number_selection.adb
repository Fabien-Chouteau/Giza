with Giza.Timers;

package body Giza.Widgets.Number_Selection is

   ---------------
   -- Triggered --
   ---------------

   function Triggered (This : Repeat_Event) return Boolean is
      Reset : Boolean := False;
   begin
      if This.Nbr = null then
         return False;
      end if;

      if This.Nbr.Plus /= null and then This.Nbr.Plus.Active then
         This.Nbr.Do_Plus;
         Reset := True;
      elsif This.Nbr.Minus /= null and then This.Nbr.Minus.Active then
         This.Nbr.Do_Minus;
         Reset := True;
      end if;

      if Reset then
         --  Reset timer
         Giza.Timers.Set_Timer (This'Unchecked_Access,
                                Clock + This.Nbr.Repeat_Time);
      end if;
      return Reset;
   end Triggered;

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
               Ctx.Print_In_Rect (Str, Value_Rect);
            end;
         end if;

         if This.Str /= null then
            Ctx.Set_Color (This.Background);
            Ctx.Fill_Rectangle (Lable_Rect);

            Ctx.Set_Color (This.Foreground);
            Ctx.Print_In_Rect (This.Str.all, Lable_Rect);
         end if;
      end if;
      This.Root.Draw (Ctx, Force);
   end Draw;

   -----------------------
   -- On_Position_Event --
   -----------------------

   overriding function On_Position_Event
     (This : in out Gnumber_Select;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean
   is
   begin
      if This.Root.On_Position_Event (Evt, Pos) then
         if This.Plus /= null and then This.Plus.Active then
            This.Do_Plus;
         elsif This.Minus /= null and then This.Minus.Active then
            This.Do_Minus;
         end if;

         This.Repeat_Evt.Nbr := This'Unchecked_Access;
         Giza.Timers.Set_Timer
           (This.Repeat_Evt'Unchecked_Access, Clock + This.Repeat_Time);
         return True;
      else
         return False;
      end if;
   end On_Position_Event;

   --------------
   -- On_Event --
   --------------

   function On_Event
     (This : in out Gnumber_Select;
      Evt  : Event_Not_Null_Ref) return Boolean is
   begin
      return This.Root.On_Event (Evt);
   end On_Event;

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

   -------------
   -- Do_Plus --
   -------------

   procedure Do_Plus (This : in out Gnumber_Select) is
   begin
      This.Value := This.Value + This.Step;
      if This.Value > This.Max then
         This.Value := This.Max;
      end if;
   end Do_Plus;

   --------------
   -- Do_Minus --
   --------------

   procedure Do_Minus (This : in out Gnumber_Select) is
   begin
      This.Value := This.Value - This.Step;
      if This.Value < This.Min then
         This.Value := This.Min;
      end if;
   end Do_Minus;

end Giza.Widgets.Number_Selection;
