with Giza.GUI;
with Giza.Widgets; use Giza.Widgets;
with Test_Tiles_Window; use Test_Tiles_Window;
with Test_Scroll_Window; use Test_Scroll_Window;

package body Test_Main_Window is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Main_Window)
   is
   begin

      This.Sub_Windows (1).Button := new Gbutton;
      This.Sub_Windows (1).Button.Set_Text ("Gtile");
      This.Sub_Windows (1).Win := new Tiles_Window;

      This.Sub_Windows (2).Button := new Gbutton;
      This.Sub_Windows (2).Button.Set_Text ("Gscroll");
      This.Sub_Windows (2).Win := new Scroll_Window;

      This.Tiles := new Gtile (This.Sub_Windows'Length, Top_Down);
      This.Tiles.Set_Size (This.Get_Size);
      This.Add_Child (Widget_Ref (This.Tiles), (0, 0));

      for Index in This.Sub_Windows'Range loop
         This.Tiles.Set_Child (Index,
                               Widget_Ref (This.Sub_Windows (Index).Button));
      end loop;
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
   function On_Click
     (This  : in out Main_Window;
      Pos   : Point_T;
      CType : Click_Type) return Boolean
   is
   begin
      if not On_Click (Window (This), Pos, CType) then
         return False;
      end if;

      for Sub of This.Sub_Windows loop
         if Sub.Win /= null
           and then
            Sub.Button /= null
           and then
            Sub.Button.Active
         then
            Sub.Button.Set_Active (False);
            Giza.GUI.Push (Sub.Win);
            return True;
         end if;
      end loop;
      return True;
   end On_Click;
end Test_Main_Window;
