with Giza.Windows;
with Giza.Widgets.Tabs; use Giza.Widgets.Tabs;
with Giza.Widgets.Composite; use Giza.Widgets.Composite;

with RPM_Widget; use RPM_Widget;
with Power_Phase_Widget; use Power_Phase_Widget;
with Giza.Widgets.Number_Selection; use Giza.Widgets.Number_Selection;
with Giza.Widgets.Button; use Giza.Widgets.Button;
with Giza.Widgets.Background; use Giza.Widgets.Background;

package Engine_Control_UI is

   type Engine_Control_Window is new Giza.Windows.Window with private;

   overriding
   procedure On_Init (This : in out Engine_Control_Window);
   overriding
   procedure On_Displayed (This : in out Engine_Control_Window);
   overriding
   procedure On_Hidden (This : in out Engine_Control_Window);

private
   type Engine_Control_Window is new Giza.Windows.Window with record
      RPM_Widget : access RPM;
      PP         : access PP_Widget;
      Tabs       : access Gtabs;
      Manual     : access Composite_Widget;
      Auto       : access Composite_Widget;
      Ignition   : access Gnumber_Select;
      Duration   : access Gnumber_Select;
      Target_RPM : access Gnumber_Select;
      Background : access Gbackground;
   end record;

end Engine_Control_UI;
