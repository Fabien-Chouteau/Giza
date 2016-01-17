with Gtk.Window; use Gtk.Window;
with Gtk.Box; use Gtk.Box;
with Gtk.Drawing_Area; use Gtk.Drawing_Area;
with Glib; use Glib;
with Cairo; use Cairo;
with Glib.Main; use Glib.Main;
with Gdk.Window; use Gdk.Window;
with Gtk.Handlers; use Gtk.Handlers;
with Ada.Text_IO; use Ada.Text_IO;
use Gdk;
with Gtk.Widget; use Gtk.Widget;
with Cairo.Image_Surface; use Cairo.Image_Surface;
with Gdk.Event; use Gdk.Event;
with Gtk.Main;

package body Screen_Interface is
   Width_Size  : constant := Width'Last - Width'First + 1;
   Height_Size : constant := Height'Last - Height'First + 1;

   function Window_Idle return Boolean;

   function Redraw (Area  : access Gtk_Drawing_Area_Record'Class;
                    Cr    : Cairo_Context) return Boolean;

   procedure Initialize_Gtk;

   function On_Motion
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Motion) return Boolean;

   function On_Button
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Button) return Boolean;

   package Event_Cb is new Gtk.Handlers.Return_Callback
     (Gtk_Drawing_Area_Record, Boolean);

   Darea : Gtk_Drawing_Area;

   subtype Frame_Buffer_Array is
     ARGB32_Array (1 .. Natural (Width_Size * Height_Size));
   pragma Unreferenced (Frame_Buffer_Array);

   --  We use a protected objet to synchonize access from GTK loop and the
   --  outside world.
   protected Protected_Interface is
      procedure Set_Pixel (P : Point; Col : Color);
      procedure Fill_Screen (Col : Color);
      procedure Draw (Cr : Cairo_Context);
      procedure Initialize;
   private
      Buffer : aliased ARGB32_Array (0 .. (Width_Size * Height_Size) - 1);
      Surface : Cairo_Surface;
   end Protected_Interface;

   protected body Protected_Interface is

      ---------------
      -- Set_Pixel --
      ---------------

      procedure Set_Pixel (P : Point; Col : Color) is
      begin
         Buffer (P.X + P.Y * Width_Size) := Col;
      end Set_Pixel;

      -----------------
      -- Fill_Screen --
      -----------------

      procedure Fill_Screen (Col : Color) is
      begin
         Buffer := (others => Col);
      end Fill_Screen;

      ----------
      -- Draw --
      ----------

      procedure Draw (Cr : Cairo_Context) is
         W : constant Gint := Darea.Get_Allocated_Width;
         H : constant Gint := Darea.Get_Allocated_Height;
         W_Ratio : constant Gdouble := Gdouble (W) / Gdouble (Width_Size);
         H_Ratio : constant Gdouble := Gdouble (H) / Gdouble (Height_Size);
      begin
         Cairo.Save (Cr);
         Cairo.Scale (Cr, W_Ratio, H_Ratio);
         Set_Source_Surface (Cr, Surface, 0.0, 0.0);
         Cairo.Paint (Cr);
         Cairo.Restore (Cr);
      end Draw;

      ----------------
      -- Initialize --
      ----------------

      procedure Initialize is
         Stride : constant Gint := Cairo_Format_Stride_For_Width
           (Format => Cairo_Format_ARGB32,
            Width  => Width_Size);
      begin
         Surface := Create_For_Data_Generic
           (Buffer (Buffer'First)'Address,
            Cairo_Format_ARGB32,
            Width_Size,
            Height_Size,
            Stride);
      end Initialize;
   end Protected_Interface;

   protected Touch is
      function Get return Touch_State;
      procedure Set (State : Touch_State);
   private
      TS : Touch_State := (False, 0, 0);
   end Touch;

   protected body Touch is

      ---------
      -- Get --
      ---------

      function Get return Touch_State is
      begin
         return TS;
      end Get;

      ---------
      -- Set --
      ---------

      procedure Set (State : Touch_State) is
      begin
         TS := State;
      end Set;
   end Touch;

   -----------------
   -- Window_Idle --
   -----------------

   function Window_Idle return Boolean
   is
      W, H  : Gint;
   begin
      if Darea = null or else Get_Window (Darea) = null then
         return True;
      end if;
      W := Darea.Get_Allocated_Width;
      H := Darea.Get_Allocated_Height;
      Invalidate_Rect (Get_Window (Darea),
                       (0, 0, W, H), Invalidate_Children => True);

      return True;
   end Window_Idle;

   ------------
   -- Redraw --
   ------------

   function Redraw (Area  : access Gtk_Drawing_Area_Record'Class;
                    Cr    : Cairo_Context) return Boolean is
      pragma Unreferenced (Area);
   begin
      if Darea = null or else Get_Window (Darea) = null then
         return True;
      end if;
      Protected_Interface.Draw (Cr);
      return False;
   end Redraw;

   ---------------
   -- On_Button --
   ---------------

   function On_Button
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Button) return Boolean is
      pragma Unreferenced (Self);

      W : constant Gdouble := Gdouble (Darea.Get_Allocated_Width);
      H : constant Gdouble := Gdouble (Darea.Get_Allocated_Height);
      TS : Touch_State;
   begin
      if Event.The_Type = Button_Press and then Event.Button = 1 then
         TS.X := Width ((Event.X / W) * Gdouble (Width_Size));
         TS.Y := Height ((Event.Y / H) * Gdouble (Height_Size));
         TS.Touch_Detected := True;
         Touch.Set (TS);
      elsif Event.The_Type = Button_Release  and then Event.Button = 1 then
         TS := Touch.Get;
         TS.Touch_Detected := False;
         Touch.Set (TS);
      end if;
      return False;
   exception
      when others =>
         Put_Line ("On_Button exception");
         TS.X := 0;
         TS.Y := 0;
         return False;
   end On_Button;

   ---------------
   -- On_Motion --
   ---------------

   function On_Motion
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Motion) return Boolean is
      pragma Unreferenced (Self);

      W  : constant Gdouble := Gdouble (Darea.Get_Allocated_Width);
      H  : constant Gdouble := Gdouble (Darea.Get_Allocated_Height);
      TS : Touch_State := Touch.Get;
   begin
      if TS.Touch_Detected then
         TS.X := Width ((Event.X / W) * Gdouble (Width_Size));
         TS.Y := Height ((Event.Y / H) * Gdouble (Height_Size));
         Touch.Set (TS);
      end if;
      return False;
   exception
      when others =>
         Put_Line ("On Motion exception");
         TS.X := 0;
         TS.Y := 0;
         Touch.Set (TS);
         return False;
   end On_Motion;

   --------------------
   -- Initialize_Gtk --
   --------------------

   procedure Initialize_Gtk is
      Win   : Gtk_Window;
      Box   : Gtk_Vbox;
      Src_Id : G_Source_Id;
      pragma Unreferenced (Src_Id);
   begin
      Protected_Interface.Initialize;

      Gtk_New (Win);
      Win.Set_Default_Size (Width_Size, Height_Size);
      Win.Add_Events (Button_Release_Mask);
      Win.Add_Events (Button_Press_Mask);
      Win.Add_Events (Pointer_Motion_Mask);
      Win.Add_Events (Pointer_Motion_Hint_Mask);
      Win.On_Button_Press_Event (On_Button'Access, True);
      Win.On_Button_Release_Event (On_Button'Access, True);
      Win.On_Motion_Notify_Event (On_Motion'Access);
      Gtk_New_Vbox (Box);

      Gtk_New (Darea);
      Win.Add (Darea);
      Event_Cb.Connect (Darea, Signal_Draw,
                        Event_Cb.To_Marshaller (Redraw'Unrestricted_Access));
      --  Show the window
      Win.Show_All;

      Src_Id := Timeout_Add (50, Window_Idle'Access);
   end Initialize_Gtk;

   --------------
   -- Gtk_Task --
   --------------

   task Gtk_Task is
      entry Start;
   end Gtk_Task;

   task body Gtk_Task is
   begin
      accept Start;
      --  Initialize GtkAda.
      Gtk.Main.Init;

      Initialize_Gtk;

      --  Start the Gtk+ main loop
      Gtk.Main.Main;
   end Gtk_Task;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Gtk_Task.Start;
   end Initialize;

   ---------------------
   -- Get_Touch_State --
   ---------------------

   function Get_Touch_State return Touch_State is
   begin
      --  Simulate touch screen communication latency
      delay 0.0005;

      return Touch.Get;
   end Get_Touch_State;

   ---------------
   -- Set_Pixel --
   ---------------

   procedure Set_Pixel (P : Point; Col : Color) is
   begin
      Protected_Interface.Set_Pixel (P, Col);
   end Set_Pixel;

   -----------------
   -- Fill_Screen --
   -----------------

   procedure Fill_Screen (Col : Color) is
   begin
      Protected_Interface.Fill_Screen (Col);
   end Fill_Screen;

   ------------------
   -- RGB_To_Color --
   ------------------

   function RGB_To_Color (R, G, B : RGB_Component) return Color is
      Result : Color;
   begin
      Result.Red := Byte (R);
      Result.Green := Byte (G);
      Result.Blue := Byte (B);
      Result.Alpha := 255;
      return Result;
   end RGB_To_Color;

   Current_Color : Color := RGB_To_Color (0, 0, 0);

   ---------------
   -- Set_Pixel --
   ---------------

   procedure Set_Pixel (This : in out GTKada_Backend; Pt : Point_T)
   is
   begin
      if This.Enabled and then Pt.X in Width and then Pt.Y in Height then
         Set_Pixel ((Pt.X, Pt.Y), Current_Color);
      end if;
   end Set_Pixel;

   ---------------
   -- Set_Color --
   ---------------

   procedure Set_Color
     (This : in out GTKada_Backend;
      C : Giza.Colors.Color) is
      pragma Unreferenced (This);
   begin
      Current_Color := RGB_To_Color (RGB_Component (C.R),
                                     RGB_Component (C.G),
                                     RGB_Component (C.B));
   end Set_Color;

   ----------
   -- Size --
   ----------

   function Size (This : GTKada_Backend) return Size_T is
      pragma Unreferenced (This);
   begin
      return (Screen_Parameters.Width'Last, Screen_Parameters.Height'Last);
   end Size;

   ------------
   -- Enable --
   ------------

   procedure Enable (This : in out GTKada_Backend) is
   begin
      This.Enabled := True;
   end Enable;

   -------------
   -- Disable --
   -------------

   procedure Disable (This : in out GTKada_Backend) is
   begin
      This.Enabled := False;
   end Disable;

end Screen_Interface;
