with Giza.Widgets.Tiles; use Giza.Widgets.Tiles;
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
      Tile_Top_Down   : Gtile_Ref;
      Tile_Bottom_Up  : Gtile_Ref;
      Tile_Right_Left : Gtile_Ref;
      Tile_Left_Right : Gtile_Ref;
   end record;
end Test_Tiles_Window;
