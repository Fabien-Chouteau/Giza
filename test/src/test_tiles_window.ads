with Giza.Windows;
with Giza.Widgets.Tiles; use Giza.Widgets.Tiles;

package Test_Tiles_Window is
   type Tiles_Window is new Giza.Windows.Window with private;
   type Tiles_Window_Ref is access all Tiles_Window;

   overriding
   procedure On_Init (This : in out Tiles_Window);
   overriding
   procedure On_Displayed (This : in out Tiles_Window);
   overriding
   procedure On_Hidden (This : in out Tiles_Window);

private
   type Tiles_Window is new Giza.Windows.Window with record
      Tile_Top_Down : Gtile_Ref;
      Tile_Bottom_Up : Gtile_Ref;
      Tile_Right_Left : Gtile_Ref;
      Tile_Left_Right : Gtile_Ref;
   end record;
end Test_Tiles_Window;
