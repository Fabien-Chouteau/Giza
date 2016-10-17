with Giza.Widgets.Scrolling;
use Giza.Widgets;
with Basic_Test_Window; use Basic_Test_Window;

package Test_Scroll_Window is
   type Scroll_Window is new Test_Window with private;
   type Scroll_Window_Ref is access all Scroll_Window;

   overriding
   procedure On_Init (This : in out Scroll_Window);
   overriding
   procedure On_Displayed (This : in out Scroll_Window);
   overriding
   procedure On_Hidden (This : in out Scroll_Window);

private
   type Scroll_Window is new Test_Window with record
      Scroll_Vert    : Scrolling.Ref;
      Scroll_Horizon : Scrolling.Ref;
      Scroll_Both    : Scrolling.Ref;
   end record;
end Test_Scroll_Window;
