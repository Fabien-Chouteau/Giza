with Basic_Test_Window; use Basic_Test_Window;
with Giza.Context; use Giza.Context;
with Giza.Events; use Giza.Events;
with Giza.Widget.Button;
use Giza.Widget;

package Test_Graphic_Bounds is

   type Graphic_Bounds_Window is new Test_Window with private;
   type Graphic_Boounds_Window_Ref is access all Graphic_Bounds_Window;

   overriding
   procedure On_Init (This : in out Graphic_Bounds_Window);
   overriding
   procedure On_Displayed (This : in out Graphic_Bounds_Window);
   overriding
   procedure On_Hidden (This : in out Graphic_Bounds_Window);

   overriding
   procedure Draw (This  : in out Graphic_Bounds_Window;
                   Ctx   : in out Giza.Context.Class;
                   Force : Boolean := True);

private

   type Graphic_Bounds_Window is new Test_Window with record
      Evt       : aliased Timer_Event;
      Bound_Btn : Button.Ref;
   end record;
end Test_Graphic_Bounds;
