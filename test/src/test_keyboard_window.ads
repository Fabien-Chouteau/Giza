with Basic_Test_Window; use Basic_Test_Window;
with Giza.Widgets.Keyboards;

package Test_Keyboard_Window is
   type Keyboard_Window is new Test_Window with private;
   type Keyboard_Window_Ref is access all Keyboard_Window;

   overriding
   procedure On_Init (This : in out Keyboard_Window);
   overriding
   procedure On_Displayed (This : in out Keyboard_Window) is null;
   overriding
   procedure On_Hidden (This : in out Keyboard_Window) is null;

private
   type Keyboard_Window is new Test_Window with record
      Keyboard : aliased Giza.Widgets.Keyboards.Instance;
   end record;
end Test_Keyboard_Window;
