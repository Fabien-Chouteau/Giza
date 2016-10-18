with Basic_Test_Window; use Basic_Test_Window;
with Giza.Widget.Number_Selection;
use Giza.Widget;

package Test_Gnumber_Window is
   type Gnumber_Window is new Test_Window with private;
   type Gnumber_Window_Ref is access all Gnumber_Window;

   overriding
   procedure On_Init (This : in out Gnumber_Window);
   overriding
   procedure On_Displayed (This : in out Gnumber_Window);
   overriding
   procedure On_Hidden (This : in out Gnumber_Window);

private
   type Gnumber_Window is new Test_Window with record
      Nbr_1, Nbr_2 : Number_Selection.Ref;
   end record;
end Test_Gnumber_Window;
