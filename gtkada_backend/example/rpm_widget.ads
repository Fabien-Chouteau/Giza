with Giza.Widgets.Frame; use Giza.Widgets.Frame;
with Giza.Graphics; use Giza.Graphics;
with Giza.Events; use Giza.Events;

package RPM_Widget is

   subtype RPM_Range is Natural range  0 .. 9999;

   type RPM is new Gframe with private;

   overriding
   procedure Draw (This : in out RPM;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);
   overriding
   function On_Event
     (This : in out RPM;
      Evt  : Event_Not_Null_Ref) return Boolean;

   procedure Set_RPM (This : in out RPM; Val : RPM_Range);
   function Get_RPM (This : RPM) return RPM_Range;

private
   type RPM is new Gframe with record
      Value : RPM_Range := 0;
   end record;
end RPM_Widget;
