with Giza.Widgets; use Giza.Widgets;
with Test_Tiles_Window; use Test_Tiles_Window;
with Giza.Graphics; use Giza.Graphics;

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
      Size : constant Size_T := This.Get_Size;
   begin
      On_Init (Test_Window (This));

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

end Test_Scroll_Window;
