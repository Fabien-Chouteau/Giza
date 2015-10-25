with Giza.Windows;
with Giza.Widgets.Tiles; use Giza.Widgets.Tiles;
with Giza.Widgets.Button; use Giza.Widgets.Button;
with Giza.Graphics; use Giza.Graphics;
with Giza.Events; use Giza.Events;

package Test_Tiles_Window is
   type Tiles_Window is new Giza.Windows.Window with private;
   type Tiles_Window_Ref is access all Tiles_Window;

   overriding
   procedure On_Init (This : in out Tiles_Window);
   overriding
   procedure On_Displayed (This : in out Tiles_Window);
   overriding
   procedure On_Hidden (This : in out Tiles_Window);
   overriding
   function On_Click
     (This  : in out Tiles_Window;
      Pos   : Point_T;
      CType : Click_Type) return Boolean;

private
   type Tiles_Window is new Giza.Windows.Window with record
      Back            : Gbutton_Ref;
      Tile_Top_Down   : Gtile_Ref;
      Tile_Bottom_Up  : Gtile_Ref;
      Tile_Right_Left : Gtile_Ref;
      Tile_Left_Right : Gtile_Ref;
   end record;
end Test_Tiles_Window;
