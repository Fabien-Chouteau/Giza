with Giza.GUI;
with Giza.Windows; use Giza.Windows;

package body Test_Main_Window is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Main_Window)
   is
   begin
      This.Test_Tiles := new Tiles_Window;
   end On_Init;

   ------------------
   -- On_Displayed --
   ------------------

   overriding procedure On_Displayed
     (This : in out Main_Window)
   is
   begin
      Giza.GUI.Push (Window_Ref (This.Test_Tiles));
   end On_Displayed;

   ---------------
   -- On_Hidden --
   ---------------

   overriding procedure On_Hidden
     (This : in out Main_Window)
   is
      pragma Unreferenced (This);
   begin
      null;
   end On_Hidden;

end Test_Main_Window;
