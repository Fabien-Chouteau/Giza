with Giza.Window; use Giza.Window;
with Giza.Widget.Button;
with Giza.Widget.Tiles; use Giza.Widget.Tiles;
with Giza.Events; use Giza.Events;
with Giza.Types; use Giza.Types;
use Giza.Widget;

package Test_Main_Window is

   subtype Parent is Giza.Window.Instance;
   type Main_Window is new Parent with private;
   type Main_Window_Ref is access all Main_Window;

   overriding
   procedure On_Init (This : in out Main_Window);
   overriding
   procedure On_Displayed (This : in out Main_Window);
   overriding
   procedure On_Hidden (This : in out Main_Window);
   overriding
   function On_Position_Event
     (This : in out Main_Window;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean;

private
   type Sub_Window is record
      Btn : Button.Ref := null;
      Win : Giza.Window.Ref := null;
   end record;

   type Sub_Window_Array is array (Positive range <>) of Sub_Window;

   type Main_Window is new Parent with record
      Btn_Tile    : Tiles.Ref;
      Sub_Windows : Sub_Window_Array (1 .. 8);
   end record;
end Test_Main_Window;
