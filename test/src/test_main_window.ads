with Giza.Windows; use Giza.Windows;
with Giza.Widgets.Button;
with Giza.Widgets.Tiles; use Giza.Widgets.Tiles;
with Giza.Events; use Giza.Events;
with Giza.Types; use Giza.Types;
use Giza.Widgets;

package Test_Main_Window is

   subtype Parent is Giza.Windows.Instance;
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
      Win : Giza.Windows.Ref := null;
   end record;

   type Sub_Window_Array is array (Positive range <>) of Sub_Window;

   type Main_Window is new Parent with record
      Btn_Tile    : Tiles.Ref;
      Sub_Windows : Sub_Window_Array (1 .. 7);
   end record;
end Test_Main_Window;
