-------------------------------------------------------------------------------
--                                                                           --
--                                   Giza                                    --
--                                                                           --
--         Copyright (C) 2016 Fabien Chouteau (chouteau@adacore.com)         --
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

package body Giza.Backends is

   ----------
   -- Line --
   ----------

   procedure Line (This : in out Backend; Start, Stop : Point_T) is
      DX     : constant Float := abs Float (Stop.X - Start.X);
      DY     : constant Float := abs Float (Stop.Y - Start.Y);
      Err    : Float;
      X      : Dim        := Start.X;
      Y      : Dim        := Start.Y;
      Step_X : Integer        := 1;
      Step_Y : Integer        := 1;

   begin
      if Start.X > Stop.X then
         Step_X := -1;
      end if;

      if Start.Y > Stop.Y then
         Step_Y := -1;
      end if;

      if DX > DY then
         Err := DX / 2.0;
         while X /= Stop.X loop
            Set_Pixel (Backend'Class (This), (X, Y));
            Err := Err - DY;
            if Err < 0.0 then
               Y := Y + Step_Y;
               Err := Err + DX;
            end if;
            X := X + Step_X;
         end loop;
      else
         Err := DY / 2.0;
         while Y /= Stop.Y loop
            Set_Pixel (Backend'Class (This), (X, Y));
            Err := Err - DX;
            if Err < 0.0 then
               X := X + Step_X;
               Err := Err + DY;
            end if;
            Y := Y + Step_Y;
         end loop;
      end if;

      Set_Pixel (Backend'Class (This), (X, Y));
   end Line;

   ---------------
   -- Rectangle --
   ---------------

   procedure Rectangle (This : in out Backend; Start, Stop : Point_T) is
   begin
      This.Line (Start, (Stop.X, Start.Y));
      This.Line ((Stop.X, Start.Y), Stop);
      This.Line (Stop, (Start.X, Stop.Y));
      This.Line ((Start.X, Stop.Y), Start);
   end Rectangle;

   --------------------
   -- Fill_Rectangle --
   --------------------

   procedure Fill_Rectangle (This : in out Backend; Start, Stop : Point_T) is
      P1 : Point_T := Start;
      P2 : Point_T := (Start.X, Stop.Y);
   begin
      loop
         This.Line (P2, P1);
         exit when P2.X = Stop.X;
         P1.X := P1.X + 1;
         P2.X := P2.X + 1;
      end loop;
   end Fill_Rectangle;

end Giza.Backends;
