with Giza.Colors; use Giza.Colors;
with Giza.Widgets; use Giza.Widgets;
with Giza.GUI;
with Giza.Windows; use Giza.Windows;

package body Test_Tiles_Window is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Tiles_Window)
   is
      function New_Text (Str : String) return Widget_Ref;

      --------------
      -- New_Text --
      --------------

      function New_Text (Str : String) return Widget_Ref is
         Txt : Gbutton_Ref;
      begin
         Txt := new Gbutton;
         Txt.Set_Text (Str);
         Txt.Set_Background (White);
         Txt.Set_Foreground (Black);
         return Widget_Ref (Txt);
      end New_Text;

      Size : Size_T;
   begin
      --  Add a back button at the bottom of the window
      This.Back := new Gbutton;
      This.Back.Set_Text ("Back");
      This.Back.Set_Size ((This.Get_Size.W, This.Get_Size.H / 10));
      This.Back.Set_Foreground (Red);
      This.Add_Child (Widget_Ref (This.Back),
                      (0, This.Get_Size.H - This.Back.Get_Size.H));

      Size := This.Get_Size - (0, This.Back.Get_Size.H);

      This.Tile_Top_Down   := new Gtile (3, Top_Down);
      This.Tile_Bottom_Up  := new Gtile (3, Bottom_Up);
      This.Tile_Right_Left := new Gtile (3, Right_Left);
      This.Tile_Left_Right := new Gtile (3, Left_Right);

      This.Tile_Top_Down.Set_Size ((Size.W / 2,
                             Size.H / 2));
      This.Tile_Bottom_Up.Set_Size (This.Tile_Top_Down.Get_Size);
      This.Tile_Right_Left.Set_Size (This.Tile_Top_Down.Get_Size);
      This.Tile_Left_Right.Set_Size (This.Tile_Top_Down.Get_Size);

      for Index in 1 .. 3 loop
         This.Tile_Top_Down.Set_Child (Index, New_Text ("TD" & Index'Img));
         This.Tile_Bottom_Up.Set_Child (Index, New_Text ("BU" & Index'Img));
         This.Tile_Right_Left.Set_Child (Index, New_Text ("RL" & Index'Img));
         This.Tile_Left_Right.Set_Child (Index, New_Text ("LR" & Index'Img));
      end loop;

      This.Add_Child (Widget_Ref (This.Tile_Top_Down),
                      (0, 0));

      This.Add_Child (Widget_Ref (This.Tile_Bottom_Up),
                      (Size.W / 2, 0));

      This.Add_Child (Widget_Ref (This.Tile_Right_Left),
                      (0, Size.H / 2));

      This.Add_Child (Widget_Ref (This.Tile_Left_Right),
                      (Size.W / 2,  Size.H / 2));
   end On_Init;

   ------------------
   -- On_Displayed --
   ------------------

   overriding procedure On_Displayed
     (This : in out Tiles_Window)
   is
      pragma Unreferenced (This);
   begin
      null;
   end On_Displayed;

   ---------------
   -- On_Hidden --
   ---------------

   overriding procedure On_Hidden
     (This : in out Tiles_Window)
   is
      pragma Unreferenced (This);
   begin
      null;
   end On_Hidden;

   --------------
   -- On_Click --
   --------------

   overriding
   function On_Click
     (This  : in out Tiles_Window;
      Pos   : Point_T;
      CType : Click_Type) return Boolean is

      Res : Boolean;
   begin
      Res := On_Click (Window (This), Pos, CType);

      if Res and then This.Back /= null and then This.Back.Active then
         This.Back.Set_Active (False);
         Giza.GUI.Pop;
      end if;

      return Res;
   end On_Click;

end Test_Tiles_Window;
