with Giza.Colors;         use Giza.Colors;
with Giza.Window;        use Giza.Window;
with Giza.Widget.Button; use Giza.Widget.Button;
with Giza.GUI;
use Giza;

package body Basic_Test_Window is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Test_Window)
   is
      --  Our real size
      Size : constant Size_T := Get_Size (Parent (This));
   begin
      --  Add a back button at the bottom of the window
      This.Back := new Button.Instance;
      This.Back.Set_Text ("Back");
      This.Back.Set_Size ((Size.W, Size.H / 10 - 1));
      This.Back.Set_Foreground (Red);
      This.Add_Child (Widget.Reference (This.Back),
                      (0, Size.H - Size.H / 10 + 1));
   end On_Init;

   -----------------------
   -- On_Position_Event --
   -----------------------

   overriding function On_Position_Event
     (This  : in out Test_Window;
      Evt   : Position_Event_Ref;
      Pos   : Point_T)
      return Boolean
   is

      Res : Boolean;
   begin
      Res := On_Position_Event (Parent (This), Evt, Pos);

      if Res and then This.Back /= null and then This.Back.Active then
         This.Back.Set_Active (False);
         Giza.GUI.Pop;
      end if;

      return Res;
   end On_Position_Event;

   overriding
   function Get_Size (This : Test_Window) return Size_T is
      --  Our real size
      Size : constant Size_T := Get_Size (Parent (This));
   begin
      --  Remove the size of "back" button
      return Size - (0, Size.H / 10);
   end Get_Size;

end Basic_Test_Window;
