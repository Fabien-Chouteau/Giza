with Giza.Windows;
with Giza.Widgets.Button; use Giza.Widgets.Button;
with Giza.Events; use Giza.Events;
with Giza.Types; use Giza.Types;

package Basic_Test_Window is
   type Test_Window is abstract new Giza.Windows.Window with private;
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
   type Test_Window is abstract new Giza.Windows.Window with record
      Back           : Gbutton_Ref;
   end record;
end Basic_Test_Window;
