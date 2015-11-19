with Giza.Widgets.Frame; use Giza.Widgets.Frame;
with Giza.Graphics; use Giza.Graphics;
with Giza.Events; use Giza.Events;

package Power_Phase_Widget is

   subtype PP_Range is Natural range  0 .. 100;

   type PP_Widget is new Gframe with private;

   overriding
   procedure Draw (This : in out PP_Widget;
                   Ctx  : in out Context'Class;
                   Force : Boolean := True);
   overriding
   function On_Event
     (This : in out PP_Widget;
      Evt  : Event_Not_Null_Ref) return Boolean;

   procedure Set_Ignition (This : in out PP_Widget; Val : PP_Range);
   procedure Set_Duration (This : in out PP_Widget; Val : PP_Range);

private
   type PP_Widget is new Gframe with record
      Ignition : PP_Range := 25;
      Duration : PP_Range := 50;
   end record;
end Power_Phase_Widget;
