with Giza.Widgets;
use Giza;

package body Test_Gnumber_Window is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Gnumber_Window)
   is
   begin
      On_Init (Test_Window (This));

      This.Nbr_1 := new Number_Selection.Instance;
      This.Nbr_1.Set_Label ("Integer");
      This.Nbr_1.Set_Min (0);
      This.Nbr_1.Set_Max (50);
      This.Nbr_1.Set_Step (1);
      This.Nbr_1.Set_Size ((This.Get_Size.W, This.Get_Size.H / 3));

      This.Add_Child (Widgets.Reference (This.Nbr_1), (0, 0));

      This.Nbr_2 := new Number_Selection.Instance;
      This.Nbr_2.Set_Label ("Big Integer");
      This.Nbr_2.Show_Value;
      This.Nbr_2.Set_Min (-50000);
      This.Nbr_2.Set_Max (50000);
      This.Nbr_2.Set_Step (1000);
      This.Nbr_2.Set_Size ((This.Get_Size.W, (This.Get_Size.H / 3) * 2));

      This.Add_Child (Widgets.Reference (This.Nbr_2),
                      (0, This.Nbr_1.Get_Size.H));
   end On_Init;

   ------------------
   -- On_Displayed --
   ------------------

   overriding procedure On_Displayed
     (This : in out Gnumber_Window)
   is
   begin
      null;
   end On_Displayed;

   ---------------
   -- On_Hidden --
   ---------------

   overriding procedure On_Hidden
     (This : in out Gnumber_Window)
   is
   begin
      null;
   end On_Hidden;

end Test_Gnumber_Window;
