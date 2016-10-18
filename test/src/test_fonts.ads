with Basic_Test_Window; use Basic_Test_Window;
with Giza.Graphics; use Giza.Graphics;
with Giza.Events; use Giza.Events;
with Giza.Types; use Giza.Types;
with Giza.Widget.Button;
with Giza.Widget.Tiles; use Giza.Widget.Tiles;
use Giza.Widget;

package Test_Fonts is

   subtype Parent is Test_Window;
   type Test_Fonts_Window is new Parent with private;
   type Test_Fonts_Window_Ref is access all Test_Fonts_Window;

   overriding
   procedure On_Init (This : in out Test_Fonts_Window);

   overriding
   procedure On_Displayed (This : in out Test_Fonts_Window) is null;

   overriding
   procedure On_Hidden (This : in out Test_Fonts_Window) is null;

   overriding
   procedure Draw (This : in out Test_Fonts_Window;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   overriding
   function On_Position_Event
     (This : in out Test_Fonts_Window;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean;

private

   type Test_Fonts_Window is new Test_Window with record
      Tile : aliased Tiles.Instance (3, Left_Right);
      Prev, Next, Boxes : aliased Button.Instance;
      Font_Index : Integer := 1;
   end record;
end Test_Fonts;
