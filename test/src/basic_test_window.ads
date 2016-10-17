with Giza.Windows;
with Giza.Widgets.Button;
use Giza.Widgets;
with Giza.Events; use Giza.Events;
with Giza.Types; use Giza.Types;

package Basic_Test_Window is
   subtype Parent is  Giza.Windows.Instance;
   type Test_Window is abstract new Parent with private;
   type Test_Window_Ref is access all Test_Window;

   overriding
   procedure On_Init (This : in out Test_Window);

   overriding
   function On_Position_Event
     (This  : in out Test_Window;
      Evt   : Position_Event_Ref;
      Pos   : Point_T) return Boolean;

   overriding
   function Get_Size (This : Test_Window) return Size_T;

private
   type Test_Window is abstract new Parent with record
      Back : Button.Ref;
   end record;
end Basic_Test_Window;
