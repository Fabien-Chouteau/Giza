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
with Cairo.Surface;
with Gdk.Event; use Gdk.Event;

package body Screen_Interface is
   Width_Size : constant := Width'Last - Width'First + 1;
   Height_Size : constant := Height'Last - Height'First + 1;

   TS : Touch_State := (False, 0, 0);

   package Event_Cb is new Gtk.Handlers.Return_Callback
     (Gtk_Drawing_Area_Record, Boolean);

   Darea : Gtk_Drawing_Area;

   subtype Frame_Buffer_Array is
     ARGB32_Array (1 .. Natural (Width_Size * Height_Size));

   --  We use a protected objet to synchonize access from GTK loop and the
   --  outside world.
   protected Frame_Buffer is
      procedure Set_Pixel (P : Point; Col : Color);
      procedure Fill_Screen (Col : Color);
      procedure Draw (Cr : Cairo_Context);
      procedure Initialize;
   private
      Buffer : aliased ARGB32_Array (0 .. (Width_Size * Height_Size) -1);
      Surface : Cairo_Surface;
   end Frame_Buffer;

   protected body Frame_Buffer is
      procedure Set_Pixel (P : Point; Col : Color) is
      begin
         Buffer (P.X + P.Y * Width_Size) := Col;
      end Set_Pixel;

      procedure Fill_Screen (Col : Color) is
      begin
         Buffer := (others => Col);
      end Fill_Screen;

      procedure Draw (Cr : Cairo_Context) is
         W : Gint := Darea.Get_Allocated_Width;
         H : Gint := Darea.Get_Allocated_Height;
         W_Ratio : Gdouble := Gdouble (W) / Gdouble (Width_Size);
         H_Ratio : Gdouble := Gdouble (H) / Gdouble (Height_Size);
      begin
         Cairo.Save (Cr);
         Cairo.Scale (Cr, W_Ratio, H_Ratio);
         Set_Source_Surface (Cr, Surface, 0.0, 0.0);
         Cairo.Paint (Cr);
         Cairo.Restore (Cr);
      end Draw;

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
   end Frame_Buffer;

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

   function Redraw (Area  : access Gtk_Drawing_Area_Record'Class;
                    Cr    : Cairo_Context) return Boolean is
      pragma Unreferenced (Area);
   begin
      if Darea = null or else Get_Window (Darea) = null then
         return True;
      end if;
      Frame_Buffer.Draw (Cr);
      return False;
   end Redraw;

    function On_Button
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Button) return Boolean;

   function On_Button
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Button) return Boolean is

      W : Gdouble := Gdouble (Darea.Get_Allocated_Width);
      H : Gdouble := Gdouble (Darea.Get_Allocated_Height);
   begin
      if Event.The_Type = Button_Press and then Event.Button = 1 then
         TS.X := Width ((Event.X / W) * Gdouble (Width_Size));
         TS.Y := Height ((Event.Y / H) * Gdouble (Height_Size));
         TS.Touch_Detected := True;
      elsif Event.The_Type = Button_Release  and then Event.Button = 1 then
         TS := (False, 0, 0);
      end if;
      return False;
   exception
      when others =>
         Put_Line ("On_Button exception");
         TS.X := 0;
         TS.Y := 0;
         return False;
   end On_Button;

   function On_Motion
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Motion) return Boolean is

      W : Gdouble := Gdouble (Darea.Get_Allocated_Width);
      H : Gdouble := Gdouble (Darea.Get_Allocated_Height);

   begin
      if TS.Touch_Detected then
         TS.X := Width ((Event.X / W) * Gdouble (Width_Size));
         TS.Y := Height ((Event.Y / H) * Gdouble (Height_Size));
      end if;
      return False;
   exception
      when others =>
         Put_Line ("On Motion exception");
         TS.X := 0;
         TS.Y := 0;
         return False;
   end On_Motion;

   procedure Initialize is
      Win   : Gtk_Window;
      Box   : Gtk_Vbox;
      Src_Id : G_Source_Id;
      pragma Unreferenced (Src_Id);
   begin
      Frame_Buffer.Initialize;

      Gtk_New (Win);
      Win.Set_Default_Size (Gint (Width'Last - Width'First + 1),
                            Gint (Height'Last - Height'First + 1));
      Win.Add_Events(Button_Release_Mask);
      Win.Add_Events(Button_Press_Mask);
      Win.Add_Events(Pointer_Motion_Mask);
      Win.Add_Events(Pointer_Motion_Hint_Mask);
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

      Src_Id := Timeout_Add (100, Window_Idle'Access);
     end;

   function Get_Touch_State return Touch_State is
   begin
      delay 0.1;
      return TS;
   end;

   procedure Set_Pixel (P : Point; Col : Color) is
   begin
      Frame_Buffer.Set_Pixel (P, Col);
   end;

   procedure Fill_Screen (Col : Color) is
   begin
      Frame_Buffer.Fill_Screen (Col);
   end Fill_Screen;

   function RGB_To_Color (R, G, B : RGB_Value) return Color is
      Result : Color;
   begin
      Result.Red := Byte (R);
      Result.Green := Byte (G);
      Result.Blue := Byte (B);
      Result.Alpha := 255;
      return Result;
   end RGB_To_Color;

end Screen_Interface;
