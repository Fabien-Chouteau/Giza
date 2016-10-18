with Giza; use Giza;
with Giza.Colors; use Giza.Colors;
with Giza.Widget;
with Giza.Widget.Button; use Giza.Widget.Button;
with Giza.Types; use Giza.Types;
with Ada.Numerics; use Ada.Numerics;
with bmp_test_data;
with hand;

package body Test_Graphic_Bounds is

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Graphic_Bounds_Window)
   is
   begin
      On_Init (Test_Window (This));
      This.Bound_Btn := new Button.Instance;
      This.Bound_Btn.Set_Size ((This.Get_Size.W, 40));
      This.Bound_Btn.Set_Text ("Bounds");
      This.Add_Child (Widget.Reference (This.Bound_Btn), (0, 0));
   end On_Init;

   ------------------
   -- On_Displayed --
   ------------------

   overriding procedure On_Displayed
     (This : in out Graphic_Bounds_Window)
   is
   begin
      null;
   end On_Displayed;

   ---------------
   -- On_Hidden --
   ---------------

   overriding procedure On_Hidden
     (This : in out Graphic_Bounds_Window)
   is
   begin
      null;
   end On_Hidden;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out Graphic_Bounds_Window;
      Ctx : in out Context'Class;
      Force : Boolean := True)
   is
      R1, R2 : Rect_T;
      Grid : constant Dim := This.Get_Size.W / 10;
   begin
      Draw (Test_Window (This), Ctx, Force);

      Ctx.Set_Color (White);
      Ctx.Fill_Rectangle (((0, 41), This.Get_Size - (0, 42)));

      R1 := ((10, 50), (20, 20));
      R2 := ((20, 60), (20, 20));
      Ctx.Set_Color (Red);
      Ctx.Fill_Rectangle (R1);
      Ctx.Set_Color (Green);
      Ctx.Fill_Rectangle (R2);
      Ctx.Set_Color (Blue);
      Ctx.Fill_Rectangle (Intersection (R1, R2));

      for Cnt in 1 .. 2 loop
         Ctx.Save;
         if Cnt = 1 then
            Ctx.Translate ((This.Get_Size.W / 3, This.Get_Size.H / 3));
         else
            Ctx.Translate ((10, 10));
         end if;

         --  Set bounds
         if This.Bound_Btn /= null and then This.Bound_Btn.Active then
            Ctx.Set_Bounds (((0, 0), This.Get_Size / 10));
         end if;

         Ctx.Set_Color ((if Cnt = 1 then Green else Red));
         Ctx.Fill_Rectangle (((-20, -20), This.Get_Size / 5));

         Ctx.Set_Color ((if Cnt = 1 then Black else White));
         Ctx.Rectangle (((0, 0), (This.Get_Size / 10)));
      end loop;
      Ctx.Restore;
      Ctx.Restore;

      Ctx.Set_Color (Blue);
      Ctx.Fill_Circle ((8 * Grid, 4 * Grid), 2 * Grid);

      Ctx.Set_Color (Orange);
      Ctx.Circle ((8 * Grid, 4 * Grid), 2 * Grid);

      Ctx.Set_Color (Green);
      Ctx.Fill_Arc ((8 * Grid, 8 * Grid), 2 * Grid, 0.0, Pi / 2.0);
      Ctx.Set_Color (Red);
      Ctx.Fill_Arc ((8 * Grid, 8 * Grid), 2 * Grid, Pi / 2.0, Pi);
      Ctx.Set_Color (Blue);
      Ctx.Fill_Arc ((8 * Grid, 8 * Grid), 2 * Grid, Pi, (3.0 * Pi) / 2.0);
      Ctx.Set_Color (Yellow);
      Ctx.Fill_Arc ((8 * Grid, 8 * Grid), 2 * Grid, (3.0 * Pi) / 2.0,
                    Pi * 2.0);

      Ctx.Copy_Bitmap (hand.Data, (0, 0));

      Ctx.Save;
      Ctx.Translate ((4 * Grid, 5 * Grid));
      Ctx.Copy_Bitmap (bmp_test_data.Data, (0, 0));
      Ctx.Restore;

      Ctx.Set_Color (Green);
      Ctx.Fill_Rounded_Rectangle (((Grid, 3 * Grid), (2 * Grid, 3 * Grid)),
                                  Grid / 2);
      Ctx.Set_Color (Red);
      Ctx.Rounded_Rectangle (((Grid, 3 * Grid), (2 * Grid, 3 * Grid)),
                            Grid / 2);

   end Draw;

end Test_Graphic_Bounds;
