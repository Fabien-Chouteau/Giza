with Giza.Windows;
with Giza.Widgets.Scrolling; use Giza.Widgets.Scrolling;
with Giza.Widgets.Button; use Giza.Widgets.Button;
with Giza.Graphics; use Giza.Graphics;
with Giza.Events; use Giza.Events;

package Test_Scroll_Window is
   type Scroll_Window is new Giza.Windows.Window with private;
   type Scroll_Window_Ref is access all Scroll_Window;

   overriding
   procedure On_Init (This : in out Scroll_Window);
   overriding
   procedure On_Displayed (This : in out Scroll_Window);
   overriding
   procedure On_Hidden (This : in out Scroll_Window);
   overriding
   function On_Click
     (This  : in out Scroll_Window;
      Pos   : Point_T;
      CType : Click_Type) return Boolean;

private
   type Scroll_Window is new Giza.Windows.Window with record
      Back           : Gbutton_Ref;
      Scroll_Vert    : Gscroll_Ref;
      Scroll_Horizon : Gscroll_Ref;
      Scroll_Both    : Gscroll_Ref;
   end record;
end Test_Scroll_Window;
