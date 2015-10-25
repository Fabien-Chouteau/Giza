with Giza.Widgets; use Giza.Widgets;
with Test_Tiles_Window; use Test_Tiles_Window;
with Giza.Colors; use Giza.Colors;
with Giza.Windows; use Giza.Windows;
with Giza.GUI;

------------------------
-- Test_Scroll_Window --
------------------------

package body Test_Scroll_Window is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Scroll_Window)
   is
      Object : Tiles_Window_Ref;
      Size : Size_T;
   begin
      --  Add a back button at the bottom of the window
      This.Back := new Gbutton;
      This.Back.Set_Text ("Back");
      This.Back.Set_Size ((This.Get_Size.W, This.Get_Size.H / 10));
      This.Back.Set_Foreground (Red);
      This.Add_Child (Widget_Ref (This.Back),
                      (0, This.Get_Size.H - This.Back.Get_Size.H));

      Size := This.Get_Size - (0, This.Back.Get_Size.H);

      This.Scroll_Vert := new Gscroll;
      This.Scroll_Horizon := new Gscroll;
      This.Scroll_Both := new Gscroll;

      This.Scroll_Vert.Set_Size ((Size.W / 2, Size.H / 2));
      Object := new Tiles_Window;
      Object.Set_Size ((This.Scroll_Vert.Get_Size.W,
                       This.Scroll_Vert.Get_Size.H * 2));
      Object.On_Init;
      This.Scroll_Vert.Set_Child (Widget_Ref (Object));

      This.Scroll_Horizon.Set_Size ((Size.W / 2, Size.H / 2));
      Object := new Tiles_Window;
      Object.Set_Size ((This.Scroll_Horizon.Get_Size.W * 2,
                       This.Scroll_Horizon.Get_Size.H));
      Object.On_Init;
      This.Scroll_Horizon.Set_Child (Widget_Ref (Object));

      This.Scroll_Both.Set_Size ((Size.W, Size.H / 2));
      Object := new Tiles_Window;
      Object.Set_Size ((This.Scroll_Horizon.Get_Size.W * 2,
                       This.Scroll_Horizon.Get_Size.H * 2));
      Object.On_Init;
      This.Scroll_Both.Set_Child (Widget_Ref (Object));

      This.Add_Child (Widget_Ref (This.Scroll_Vert),
                      (0, 0));

      This.Add_Child (Widget_Ref (This.Scroll_Horizon),
                      (Size.W / 2, 0));

      This.Add_Child (Widget_Ref (This.Scroll_Both),
                      (0, Size.H / 2));

   end On_Init;

   ------------------
   -- On_Displayed --
   ------------------

   overriding procedure On_Displayed
     (This : in out Scroll_Window)
   is
   begin
      null;
   end On_Displayed;

   ---------------
   -- On_Hidden --
   ---------------

   overriding procedure On_Hidden
     (This : in out Scroll_Window)
   is
   begin
      null;
   end On_Hidden;

   --------------
   -- On_Click --
   --------------

   overriding
   function On_Click
     (This  : in out Scroll_Window;
      Pos   : Point_T;
      CType : Click_Type) return Boolean is

      Res : Boolean;
   begin
      Res := On_Click (Window (This), Pos, CType);

      if Res and then This.Back /= null and then This.Back.Active then
         This.Back.Set_Active (False);
         Giza.GUI.Pop;
      end if;

      return Res;
   end On_Click;

end Test_Scroll_Window;
