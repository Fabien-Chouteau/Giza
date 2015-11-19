with Giza.Colors; use Giza.Colors;
with Giza.GUI; use Giza.GUI;

with Ada.Text_IO; use Ada.Text_IO;
with Engine_Control_Events; use Engine_Control_Events;
package body Engine_Control_UI is

   Set_PP_Evt : aliased Set_PP_Event;

   -------------
   -- On_Init --
   -------------

   procedure On_Init (This : in out Engine_Control_Window) is

   begin
      This.RPM_Widget := new RPM;
      This.RPM_Widget.Set_Background (White);
      This.RPM_Widget.Set_Foreground (Black);
      This.RPM_Widget.Disable_Frame;
      This.RPM_Widget.Set_Size ((This.Get_Size.W - 2, 38));
      This.Add_Child (This.RPM_Widget, (1, 1));

      This.PP := new PP_Widget;
      This.PP.Set_Background (White);
      This.PP.Set_Foreground (Red);
      This.PP.Disable_Frame;
      This.PP.Set_Size ((This.Get_Size.W - 2, 160));
      This.Add_Child (This.PP, (1, 41));

      This.Tabs := new Gtabs (2);
      This.Tabs.Set_Size ((This.Get_Size.W, 116));

      This.Manual := new Composite_Widget;
      This.Auto   := new Composite_Widget;
      This.Tabs.Set_Tab (1, "MANUAL", This.Manual);
      This.Tabs.Set_Tab (2, "AUTO", This.Auto);
      This.Add_Child (This.Tabs, (0, 202));

      This.Ignition := new Gnumber_Select;
      This.Ignition.Set_Size ((This.Get_Size.W, 42));
      This.Ignition.Set_Label ("Ignition");
      This.Ignition.Set_Min (0);
      This.Ignition.Set_Max (100);
      This.Ignition.Set_Step (5);
      This.Ignition.Set_Value (25);

      This.Duration := new Gnumber_Select;
      This.Duration.Set_Size ((This.Get_Size.W, 42));
      This.Duration.Set_Label ("Duration");
      This.Duration.Set_Min (0);
      This.Duration.Set_Max (100);
      This.Duration.Set_Step (5);
      This.Duration.Set_Value (50);

      This.Manual.Add_Child (This.Ignition, (0, 0));
      This.Manual.Add_Child (This.Duration, (0, 43));
      This.Tabs.Set_Selected (1);

      This.Target_RPM := new Gnumber_Select;
      This.Target_RPM.Set_Label ("Target RPM");
      This.Target_RPM.Set_Size ((This.Get_Size.W, 85));
      This.Target_RPM.Set_Min (200);
      This.Target_RPM.Set_Max (2500);
      This.Target_RPM.Set_Step (100);
      This.Target_RPM.Set_Value (1500);
      This.Target_RPM.Show_Value;

      This.Auto.Add_Child (This.Target_RPM, (0, 0));

      This.Background := new Gbackground;
      This.Background.Set_Background (Black);
      This.Background.Set_Size (This.Get_Size);

      This.Add_Child (This.Background, (0, 0));
   end On_Init;

   ------------------
   -- On_Displayed --
   ------------------

   procedure On_Displayed (This : in out Engine_Control_Window) is
   begin
      null;
   end On_Displayed;

   ---------------
   -- On_Hidden --
   ---------------

   procedure On_Hidden (This : in out Engine_Control_Window) is
   begin
      null;
   end On_Hidden;

   -----------------------
   -- On_Position_Event --
   -----------------------

   function On_Position_Event
     (This : in out Engine_Control_Window;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean
   is
   begin
      if Giza.Widgets.Composite.On_Position_Event
        (Giza.Widgets.Composite.Composite_Widget (This), Evt, Pos)
      then
         Set_PP_Evt := (Ignition => This.Ignition.Value,
                        Duration => This.Duration.Value);
         Giza.GUI.Emit (Set_PP_Evt'Access);
         return True;
      else
         return False;
      end if;
   end On_Position_Event;


end Engine_Control_UI;
