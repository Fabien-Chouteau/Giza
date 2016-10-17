with Giza.Colors; use Giza.Colors;
with Giza.Widgets;
with Giza.Widgets.Button;
with Giza.Types; use Giza.Types;
use Giza;

package body Test_Tiles_Window is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Tiles_Window)
   is
      function New_Text (Str : String) return Widgets.Reference;

      --------------
      -- New_Text --
      --------------

      function New_Text (Str : String) return Widgets.Reference is
         Txt : Button.Ref;
      begin
         Txt := new Button.Instance;
         Txt.Set_Text (Str);
         Txt.Set_Background (White);
         Txt.Set_Foreground (Black);
         return Widgets.Reference (Txt);
      end New_Text;

      Size : constant Size_T := This.Get_Size;
   begin
      On_Init (Test_Window (This));

      This.Tile_Top_Down   := new Tiles.Instance (3, Tiles.Top_Down);
      This.Tile_Bottom_Up  := new Tiles.Instance (3, Tiles.Bottom_Up);
      This.Tile_Right_Left := new Tiles.Instance (3, Tiles.Right_Left);
      This.Tile_Left_Right := new Tiles.Instance (3, Tiles.Left_Right);

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

      This.Add_Child (Widgets.Reference (This.Tile_Top_Down),
                      (0, 0));

      This.Add_Child (Widgets.Reference (This.Tile_Bottom_Up),
                      (Size.W / 2, 0));

      This.Add_Child (Widgets.Reference (This.Tile_Right_Left),
                      (0, Size.H / 2));

      This.Add_Child (Widgets.Reference (This.Tile_Left_Right),
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

end Test_Tiles_Window;
