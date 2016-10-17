-------------------------------------------------------------------------------
--                                                                           --
--                                   Giza                                    --
--                                                                           --
--         Copyright (C) 2016 Fabien Chouteau (chouteau@adacore.com)         --
--                                                                           --
--                                                                           --
--    Giza is free software: you can redistribute it and/or modify it        --
--    under the terms of the GNU General Public License as published by      --
--    the Free Software Foundation, either version 3 of the License, or      --
--    (at your option) any later version.                                    --
--                                                                           --
--    Giza is distributed in the hope that it will be useful, but WITHOUT    --
--    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY     --
--    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public        --
--    License for more details.                                              --
--                                                                           --
--    You should have received a copy of the GNU General Public License      --
--    along with Giza. If not, see <http://www.gnu.org/licenses/>.           --
--                                                                           --
-------------------------------------------------------------------------------

package body Giza.Widgets.Keyboards is

   procedure Set_Keymap (This    : in out Instance;
                         Special : Boolean := False;
                         Caps    : Boolean := False);
   ----------------
   -- Set_Keymap --
   ----------------

   procedure Set_Keymap (This    : in out Instance;
                         Special : Boolean := False;
                         Caps    : Boolean := False) is
   begin
      if Special then
         This.Buttons (Btn_1).Set_Text ("!");
         This.Buttons (Btn_2).Set_Text ("@");
         This.Buttons (Btn_3).Set_Text ("#");
         This.Buttons (Btn_4).Set_Text ("$");
         This.Buttons (Btn_5).Set_Text ("%");
         This.Buttons (Btn_6).Set_Text ("^");
         This.Buttons (Btn_7).Set_Text ("&");
         This.Buttons (Btn_8).Set_Text ("*");
         This.Buttons (Btn_9).Set_Text ("(");
         This.Buttons (Btn_0).Set_Text (")");
      else
         This.Buttons (Btn_1).Set_Text ("1");
         This.Buttons (Btn_2).Set_Text ("2");
         This.Buttons (Btn_3).Set_Text ("3");
         This.Buttons (Btn_4).Set_Text ("4");
         This.Buttons (Btn_5).Set_Text ("5");
         This.Buttons (Btn_6).Set_Text ("6");
         This.Buttons (Btn_7).Set_Text ("7");
         This.Buttons (Btn_8).Set_Text ("8");
         This.Buttons (Btn_9).Set_Text ("9");
         This.Buttons (Btn_0).Set_Text ("0");
      end if;

      if Special then
         This.Buttons (Btn_Q).Set_Text ("<");
         This.Buttons (Btn_W).Set_Text (">");
         This.Buttons (Btn_E).Set_Text ("\");
         This.Buttons (Btn_R).Set_Text ("/");
         This.Buttons (Btn_T).Set_Text ("""");
         This.Buttons (Btn_Y).Set_Text ("'");
         This.Buttons (Btn_U).Set_Text ("{");
         This.Buttons (Btn_I).Set_Text ("}");
         This.Buttons (Btn_O).Set_Text ("[");
         This.Buttons (Btn_P).Set_Text ("]");
      elsif Caps then
         This.Buttons (Btn_Q).Set_Text ("Q");
         This.Buttons (Btn_W).Set_Text ("W");
         This.Buttons (Btn_E).Set_Text ("E");
         This.Buttons (Btn_R).Set_Text ("R");
         This.Buttons (Btn_T).Set_Text ("T");
         This.Buttons (Btn_Y).Set_Text ("Y");
         This.Buttons (Btn_U).Set_Text ("U");
         This.Buttons (Btn_I).Set_Text ("I");
         This.Buttons (Btn_O).Set_Text ("O");
         This.Buttons (Btn_P).Set_Text ("P");
      else
         This.Buttons (Btn_Q).Set_Text ("q");
         This.Buttons (Btn_W).Set_Text ("w");
         This.Buttons (Btn_E).Set_Text ("e");
         This.Buttons (Btn_R).Set_Text ("r");
         This.Buttons (Btn_T).Set_Text ("t");
         This.Buttons (Btn_Y).Set_Text ("y");
         This.Buttons (Btn_U).Set_Text ("u");
         This.Buttons (Btn_I).Set_Text ("i");
         This.Buttons (Btn_O).Set_Text ("o");
         This.Buttons (Btn_P).Set_Text ("p");
      end if;

      This.Buttons (Btn_Caps).Set_Text ("Caps");

      if Special then
         This.Buttons (Btn_A).Set_Text ("~");
         This.Buttons (Btn_S).Set_Text ("`");
         This.Buttons (Btn_D).Set_Text (":");
         This.Buttons (Btn_F).Set_Text (";");
         This.Buttons (Btn_G).Set_Text (",");
         This.Buttons (Btn_H).Set_Text (".");
         This.Buttons (Btn_J).Set_Text ("?");
         This.Buttons (Btn_K).Set_Text ("");
         This.Buttons (Btn_L).Set_Text ("");
      elsif Caps then
         This.Buttons (Btn_A).Set_Text ("A");
         This.Buttons (Btn_S).Set_Text ("S");
         This.Buttons (Btn_D).Set_Text ("D");
         This.Buttons (Btn_F).Set_Text ("F");
         This.Buttons (Btn_G).Set_Text ("G");
         This.Buttons (Btn_H).Set_Text ("H");
         This.Buttons (Btn_J).Set_Text ("J");
         This.Buttons (Btn_K).Set_Text ("K");
         This.Buttons (Btn_L).Set_Text ("L");
      else
         This.Buttons (Btn_A).Set_Text ("a");
         This.Buttons (Btn_S).Set_Text ("s");
         This.Buttons (Btn_D).Set_Text ("d");
         This.Buttons (Btn_F).Set_Text ("f");
         This.Buttons (Btn_G).Set_Text ("g");
         This.Buttons (Btn_H).Set_Text ("h");
         This.Buttons (Btn_J).Set_Text ("j");
         This.Buttons (Btn_K).Set_Text ("k");
         This.Buttons (Btn_L).Set_Text ("l");
      end if;

      This.Buttons (Btn_Nothing).Set_Text ("");
      if Special then
         This.Buttons (Btn_Z).Set_Text ("_");
         This.Buttons (Btn_X).Set_Text ("-");
         This.Buttons (Btn_C).Set_Text ("+");
         This.Buttons (Btn_V).Set_Text ("=");
         This.Buttons (Btn_B).Set_Text ("");
         This.Buttons (Btn_N).Set_Text ("");
         This.Buttons (Btn_M).Set_Text ("");
      elsif Caps then
         This.Buttons (Btn_Z).Set_Text ("Z");
         This.Buttons (Btn_X).Set_Text ("X");
         This.Buttons (Btn_C).Set_Text ("C");
         This.Buttons (Btn_V).Set_Text ("V");
         This.Buttons (Btn_B).Set_Text ("B");
         This.Buttons (Btn_N).Set_Text ("N");
         This.Buttons (Btn_M).Set_Text ("M");
      else
         This.Buttons (Btn_Z).Set_Text ("z");
         This.Buttons (Btn_X).Set_Text ("x");
         This.Buttons (Btn_C).Set_Text ("c");
         This.Buttons (Btn_V).Set_Text ("v");
         This.Buttons (Btn_B).Set_Text ("b");
         This.Buttons (Btn_N).Set_Text ("n");
         This.Buttons (Btn_M).Set_Text ("m");
      end if;
      This.Buttons (Btn_Del).Set_Text ("Del");
      This.Buttons (Btn_Return).Set_Text ("<-|");

      if Special then
         This.Buttons (Btn_Special).Set_Text ("ABC");
      else
         This.Buttons (Btn_Special).Set_Text (".?;!");
      end if;
      This.Buttons (Btn_Space).Set_Text ("space");
      This.Buttons (Btn_OK).Set_Text ("OK");

   end Set_Keymap;

   -------------
   -- On_Init --
   -------------

   procedure On_Init
     (This : in out Instance)
   is
      Win_Size : constant Size_T := This.Get_Size;
      Keyboard_Size : constant Size_T := (Win_Size.W, Win_Size.H / 2);
      Text_Size : constant Size_T :=
        (Win_Size.W, Win_Size.H - Keyboard_Size.H);
   begin
      This.Root.Set_Size (Keyboard_Size);
      This.Add_Child (This.Root'Unchecked_Access,
                      (0, Win_Size.H - Keyboard_Size.H));

      for Row in 1 .. 4 loop
         This.Root.Set_Child (Row,
                              This.Lines (Row)'Unchecked_Access);
      end loop;

      for Button in Btn_1 .. Btn_Return loop
         This.Lines (Button_To_Pos (Button).Line).Set_Child
           (Button_To_Pos (Button).Row,
            This.Buttons (Button)'Unchecked_Access);
      end loop;

      --  The last line with space bar
      This.Root.Set_Child (5, This.Last_Line'Unchecked_Access);
      This.Last_Line.Set_Child
        (1, This.Buttons (Btn_Special)'Unchecked_Access);
      This.Last_Line.Set_Child
        (2, This.Buttons (Btn_Space)'Unchecked_Access);
      This.Last_Line.Set_Child
        (3, This.Buttons (Btn_OK)'Unchecked_Access);

      Set_Keymap (This);

      --  Text Display
      This.Text_Display.Set_Size (Text_Size);
      This.Add_Child (This.Text_Display'Unchecked_Access, (0, 0));
   end On_Init;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw (This  : in out Instance;
                              Ctx   : in out Context'Class;
                              Force : Boolean := True)
   is
   begin
      if not This.Initialised then
         This.On_Init;
         This.Initialised := True;
      end if;
      Draw (Parent (This), Ctx, Force);
   end Draw;

   -----------------------
   -- On_Position_Event --
   -----------------------

   overriding function On_Position_Event
     (This  : in out Instance;
      Evt   : Position_Event_Ref;
      Pos   : Point_T)
      return Boolean
   is
   begin
      if On_Position_Event (Parent (This), Evt, Pos) then
         for Button_Index in This.Buttons'Range loop
            if This.Buttons (Button_Index).Active then
               case Button_Index is
               when Btn_1 .. Btn_P | Btn_A .. Btn_L | Btn_Z .. Btn_M =>
                  if This.Text_Display.Text'Length < This.Max_Text_Len then
                     This.Text_Display.Set_Text
                       (This.Text_Display.Text &
                          This.Buttons (Button_Index).Text);
                  end if;
                  when Btn_Space =>
                     if This.Text_Display.Text'Length < This.Max_Text_Len then
                        This.Text_Display.Set_Text
                          (This.Text_Display.Text & " ");
                     end if;
                  when Btn_Del =>
                     declare
                        Str : constant String := This.Text_Display.Text;
                     begin

                        This.Text_Display.Set_Text
                          (Str (Str'First .. Str'Last - 1));
                     end;
                  when Btn_Special =>
                     if This.Buttons (Button_Index).Text = "ABC" then
                        This.Special := False;
                     else
                        This.Special := True;
                     end if;
                     Set_Keymap (This, This.Special, This.Caps);
                  when Btn_Caps =>
                     This.Caps := not This.Caps;
                     Set_Keymap (This, This.Special, This.Caps);
                  when others => null;
               end case;
            end if;
         end loop;
         return True;
      else
         return False;
      end if;
   end On_Position_Event;

   --------------------------
   -- Set_Max_Entry_Length --
   --------------------------

   procedure Set_Max_Entry_Length (This : in out Instance; Len : Natural) is
   begin
      This.Max_Text_Len := Len;
   end Set_Max_Entry_Length;

   --------------
   -- Get_Text --
   --------------

   function Get_Text (This : Instance) return String is
   begin
      return This.Text_Display.Text;
   end Get_Text;

end Giza.Widgets.Keyboards;
