with Giza.Widgets; use Giza.Widgets;
with hand;
with hand_2;

package body Test_Button_Window is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Button_Window)
   is
   begin
      On_Init (Test_Window (This));

      This.Button_1 := new Gbutton;
      This.Button_1.Set_Text ("Button");
      This.Button_1.Set_Size ((This.Get_Size.W, This.Get_Size.H / 3));

      This.Add_Child (Widget_Ref (This.Button_1), (0, 0));

      This.Button_2 := new Gbutton;
      This.Button_2.Set_Text ("Toggle");
      This.Button_2.Set_Toggle;
      This.Button_2.Set_Size ((This.Get_Size.W, This.Get_Size.H / 3));

      This.Add_Child (Widget_Ref (This.Button_2),
                      (0, This.Button_1.Get_Size.H));

      This.Button_3 := new Gbutton;
      This.Button_3.Set_Image (hand.Image'Access);
      This.Button_3.Set_Invert_Image (hand_2.Image'Access);
      This.Button_3.Set_Size ((This.Get_Size.W, This.Get_Size.H / 3));

      This.Add_Child (Widget_Ref (This.Button_3),
                      (0, This.Button_1.Get_Size.H * 2));
   end On_Init;

   ------------------
   -- On_Displayed --
   ------------------

   overriding procedure On_Displayed
     (This : in out Button_Window)
   is
      pragma Unreferenced (This);
   begin
      null;
   end On_Displayed;

   ---------------
   -- On_Hidden --
   ---------------

   overriding procedure On_Hidden
     (This : in out Button_Window)
   is
      pragma Unreferenced (This);
   begin
      null;
   end On_Hidden;

end Test_Button_Window;
