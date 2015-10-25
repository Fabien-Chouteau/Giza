with Giza.Widgets.Frame; use Giza.Widgets.Frame;
with Giza.Graphics; use Giza.Graphics;

package RPM_Widget is

   subtype RPM_Range is Natural range  0 .. 9999;

   type RPM is new Gframe with private;

   overriding
   procedure Draw (This : in out RPM;
                   Ctx : in out Context'Class;
                   Force : Boolean := True);

   procedure Set_RPM (This : in out RPM; Val : RPM_Range);
   function Get_RPM (This : RPM) return RPM_Range;

private
   type RPM is new Gframe with record
      Value : RPM_Range := 0;
   end record;
end RPM_Widget;
