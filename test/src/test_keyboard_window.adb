package body Test_Keyboard_Window is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Keyboard_Window)
   is
   begin
      On_Init (Test_Window (This));

      This.Keyboard.Set_Size (This.Get_Size);
      This.Add_Child (This.Keyboard'Unchecked_Access, (0, 0));
   end On_Init;

end Test_Keyboard_Window;
