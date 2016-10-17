with Giza.GUI;
with Giza.Widgets;
with Giza.Widgets.Button; use Giza.Widgets.Button;
use Giza;
with Test_Tiles_Window; use Test_Tiles_Window;
with Test_Scroll_Window; use Test_Scroll_Window;
with Test_Button_Window; use Test_Button_Window;
with Test_Gnumber_Window; use Test_Gnumber_Window;
with Test_Graphic_Bounds; use Test_Graphic_Bounds;
with Test_Fonts;
with Test_Keyboard_Window;

package body Test_Main_Window is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Main_Window)
   is
   begin
      This.Sub_Windows (1).Btn := new Button.Instance;
      This.Sub_Windows (1).Btn.Set_Text ("Gtile");
      This.Sub_Windows (1).Win := new Tiles_Window;

      This.Sub_Windows (2).Btn := new Button.Instance;
      This.Sub_Windows (2).Btn.Set_Text ("Gscroll");
      This.Sub_Windows (2).Win := new Scroll_Window;

      This.Sub_Windows (3).Btn := new Button.Instance;
      This.Sub_Windows (3).Btn.Set_Text ("Button");
      This.Sub_Windows (3).Win := new Button_Window;

      This.Sub_Windows (4).Btn := new Button.Instance;
      This.Sub_Windows (4).Btn.Set_Text ("Number_Select");
      This.Sub_Windows (4).Win := new Gnumber_Window;

      This.Sub_Windows (5).Btn := new Button.Instance;
      This.Sub_Windows (5).Btn.Set_Text ("Graphics");
      This.Sub_Windows (5).Win := new Graphic_Bounds_Window;

      This.Sub_Windows (6).Btn := new Button.Instance;
      This.Sub_Windows (6).Btn.Set_Text ("Keyboard");
      This.Sub_Windows (6).Win := new Test_Keyboard_Window.Keyboard_Window;

      This.Sub_Windows (7).Btn := new Button.Instance;
      This.Sub_Windows (7).Btn.Set_Text ("Fonts");
      This.Sub_Windows (7).Win := new Test_Fonts.Test_Fonts_Window;

      This.Btn_Tile := new Tiles.Instance (This.Sub_Windows'Length, Top_Down);
      This.Btn_Tile.Set_Size (This.Get_Size);
      This.Add_Child (Widgets.Reference (This.Btn_Tile), (0, 0));

      for Index in This.Sub_Windows'Range loop
         This.Sub_Windows (Index).Btn.Set_Rounded (20);
         This.Btn_Tile.Set_Child
           (Index, Widgets.Reference (This.Sub_Windows (Index).Btn));
      end loop;

      --  Uncomment to directly open a specific test window
      --  Giza.GUI.Push (This.Sub_Windows (7).Win);
   end On_Init;

   ------------------
   -- On_Displayed --
   ------------------

   overriding procedure On_Displayed
     (This : in out Main_Window)
   is
   begin
      null;
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

   --------------
   -- On_Click --
   --------------

   overriding
   function On_Position_Event
     (This : in out Main_Window;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean
   is
   begin
      if not On_Position_Event (Parent (This), Evt, Pos) then
         return False;
      end if;

      for Sub of This.Sub_Windows loop
         if Sub.Win /= null
           and then
            Sub.Btn /= null
           and then
            Sub.Btn.Active
         then
            Sub.Btn.Set_Active (False);
            Giza.GUI.Push (Sub.Win);
            return True;
         end if;
      end loop;
      return True;
   end On_Position_Event;
end Test_Main_Window;
