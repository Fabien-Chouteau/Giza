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

package body Giza.Windows is

   ----------
   -- Draw --
   ----------

   overriding
   procedure Draw (This : in out Window;
                   Ctx : in out Context'Class;
                   Force : Boolean := True)
   is
   begin
      --  TODO: Fill background
      Draw (Composite_Widget (This), Ctx, Force);
   end Draw;

   procedure On_Pushed (This : in out Window) is
   begin
      if not This.Initialized then
         On_Init (Window'Class (This));
         This.Initialized := True;
      end if;

      On_Displayed (Window'Class (This));
   end On_Pushed;

end Giza.Windows;
