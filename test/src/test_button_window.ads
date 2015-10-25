with Basic_Test_Window; use Basic_Test_Window;
with Giza.Widgets.Button; use Giza.Widgets.Button;

package Test_Button_Window is
   type Button_Window is new Test_Window with private;
   type Button_Window_Ref is access all Button_Window;

   overriding
   procedure On_Init (This : in out Button_Window);
   overriding
   procedure On_Displayed (This : in out Button_Window);
   overriding
   procedure On_Hidden (This : in out Button_Window);

private
   type Button_Window is new Test_Window with record
      Button_1, Button_2 : Gbutton_Ref;
   end record;
end Test_Button_Window;
