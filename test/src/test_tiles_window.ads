with Giza.Widgets.Tiles;
use Giza.Widgets;
with Basic_Test_Window; use Basic_Test_Window;

package Test_Tiles_Window is
   type Tiles_Window is new Test_Window with private;
   type Tiles_Window_Ref is access all Tiles_Window;

   overriding
   procedure On_Init (This : in out Tiles_Window);
   overriding
   procedure On_Displayed (This : in out Tiles_Window);
   overriding
   procedure On_Hidden (This : in out Tiles_Window);

private
   type Tiles_Window is new Test_Window with record
      Tile_Top_Down   : Tiles.Ref;
      Tile_Bottom_Up  : Tiles.Ref;
      Tile_Right_Left : Tiles.Ref;
      Tile_Left_Right : Tiles.Ref;
   end record;
end Test_Tiles_Window;
