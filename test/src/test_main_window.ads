with Giza.Windows;
with Test_Tiles_Window; use Test_Tiles_Window;

package Test_Main_Window is
   type Main_Window is new Giza.Windows.Window with private;
   type Main_Window_Ref is access all Main_Window;

   overriding
   procedure On_Init (This : in out Main_Window);
   overriding
   procedure On_Displayed (This : in out Main_Window);
   overriding
   procedure On_Hidden (This : in out Main_Window);

private
   type Main_Window is new Giza.Windows.Window with record
      Test_Tiles : Tiles_Window_Ref;
   end record;
end Test_Main_Window;
