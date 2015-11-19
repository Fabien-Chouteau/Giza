-------------------------------------------------------------------------------
--                                                                           --
--                                   Giza                                    --
--                                                                           --
--         Copyright (C) 2015 Fabien Chouteau (chouteau@adacore.com)         --
--                                                                           --
--                                                                           --
--    Giza is free software: you can redistribute it and/or modify it        --
--    under the terms of the GNU General Public License as published by      --
--    the Free Software Foundation, either version 3 of the License, or      --
--    (at your option) any later version.                                    --
--                                                                           --
--    Giza is distributed in the hope that it will be useful, but WITHOUT    --
--    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY     --
--    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public        --
--    License for more details.                                              --
--                                                                           --
--    You should have received a copy of the GNU General Public License      --
--    along with Giza. If not, see <http://www.gnu.org/licenses/>.           --
--                                                                           --
-------------------------------------------------------------------------------

package body Giza.Widgets.Tiles is

   ---------------
   -- Set_Dirty --
   ---------------

   procedure Set_Dirty (This : in out Gtile;
                        Dirty : Boolean := True)
   is
   begin
      for Index in This.Widgs'Range loop
         if This.Widgs (Index) /= null then
            This.Widgs (Index).Set_Dirty (Dirty);
         end if;
      end loop;
   end Set_Dirty;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out Gtile;
      Ctx : in out Context'Class;
      Force : Boolean := True)
   is
      W, H : Integer;
      Margin : constant Integer := 1;

      procedure Draw_Tile (Index : Integer);

      ---------------
      -- Draw_Tile --
      ---------------

      procedure Draw_Tile (Index : Integer) is
      begin
         if Index in This.Widgs'Range and then This.Widgs (Index) /= null then
            --  Ctx.Set_Bounds ((My_Bounds.Org + Ref.Pos, Ref.Widg.Get_Size));
            This.Widgs (Index).Set_Size ((W, H));
            Ctx.Set_Position ((0, 0));
            Ctx.Save;
            Ctx.Set_Bounds (((0, 0), (W, H)));
            Draw (This.Widgs (Index).all, Ctx, Force);
            Ctx.Restore;

            --  Translate for next tile
            case This.Dir is
            when Top_Down | Bottom_Up =>
               Ctx.Translate ((0, This.Spacing + H));
            when Left_Right | Right_Left =>
               Ctx.Translate ((This.Spacing + W, 0));
            end case;
         end if;

      end Draw_Tile;
   begin
      if This.Dirty or else Force then
         Draw (Gbackground (This), Ctx, Force);
      end if;

      case This.Dir is
         when Top_Down | Bottom_Up =>
            H := This.Get_Size.H;
            H := H - 2 * This.Margin;
            H := H - (This.Number_Of_Widget - 1) * This.Spacing;
            H := H / This.Number_Of_Widget;

            W := This.Get_Size.W - 2 * This.Margin;
         when Left_Right | Right_Left =>
            W := This.Get_Size.W;
            W := W - 2 * This.Margin;
            W := W - (This.Number_Of_Widget - 1) * This.Spacing;
            W := W / This.Number_Of_Widget;

            H := This.Get_Size.H - 2 * This.Margin;
      end case;

      Ctx.Save;
      Ctx.Translate ((Margin, Margin));

      if This.Dir = Left_Right or else This.Dir = Top_Down then
         for Index in This.Widgs'Range loop
            Draw_Tile (Index);
         end loop;
      else
         for Index in reverse This.Widgs'Range loop
            Draw_Tile (Index);
         end loop;
      end if;

      Ctx.Restore;
   end Draw;

   -----------------------
   -- On_Position_Event --
   -----------------------

   overriding
   function On_Position_Event
     (This : in out Gtile;
      Evt  : Position_Event_Ref;
      Pos  : Point_T)
      return Boolean
   is
      W, H : Integer;
   begin

      case This.Dir is
         when Top_Down | Bottom_Up =>
            H := This.Get_Size.H / This.Number_Of_Widget;
         when Left_Right | Right_Left =>
            W := This.Get_Size.W / This.Number_Of_Widget;
      end case;

      for Index in This.Widgs'Range loop
         case This.Dir is
         when Top_Down =>
            if Pos.Y in (Index - 1) * H .. Index * H then
               return On_Position_Event (This.Widgs (Index).all,
                                         Evt,
                                         Pos - (0, (Index - 1) * H));
            end if;
         when Bottom_Up =>
            if Pos.Y in (This.Widgs'Last - Index) * H ..
              (This.Widgs'Last - Index + 1) * H
            then

               return On_Position_Event
                 (This.Widgs (Index).all,
                  Evt,
                  Pos - (0, (This.Widgs'Last - Index) * H));
            end if;
         when Left_Right =>
            if Pos.X in (Index - 1) * W .. Index * W then
               return On_Position_Event (This.Widgs (Index).all,
                                         Evt,
                                         Pos - ((Index - 1) * W, 0));
            end if;
         when Right_Left =>
            if Pos.X in (This.Widgs'Last - Index) * W ..
              (This.Widgs'Last - Index + 1) * W
            then
               return On_Position_Event (This.Widgs (Index).all,
                                         Evt,
                                         Pos - ((Index - 1) * W, 0));
            end if;
         end case;
      end loop;
      return False;
   end On_Position_Event;

   --------------
   -- On_Event --
   --------------

   function On_Event
     (This : in out Gtile;
      Evt  : Event_Not_Null_Ref) return Boolean
   is
      Handled : Boolean := False;
   begin
      for W of This.Widgs loop
         if W /= null then
            Handled := Handled or W.On_Event (Evt);
         end if;
      end loop;
      return Handled;
   end On_Event;

   ---------------
   -- Set_Child --
   ---------------

   procedure Set_Child
     (This  : in out Gtile;
      Index : Positive;
      Child : Widget_Ref)
   is
   begin
      if Index in This.Widgs'Range then
         This.Widgs (Index) := Child;
      end if;
   end Set_Child;

   -----------------
   -- Set_Spacing --
   -----------------

   procedure Set_Spacing (This : in out Gtile; Spacing : Natural) is
   begin
      This.Spacing := Spacing;
   end Set_Spacing;

   ----------------
   -- Set_Margin --
   ----------------

   procedure Set_Margin (This : in out Gtile; Margin : Natural) is
   begin
      This.Margin := Margin;
   end Set_Margin;

end Giza.Widgets.Tiles;
