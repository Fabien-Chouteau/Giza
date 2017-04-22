------------------------------------------------------------------------------
--                                                                          --
--                                   Giza                                   --
--                                                                          --
--         Copyright (C) 2016 Fabien Chouteau (chouteau@adacore.com)        --
--                                                                          --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with Giza.Widget.Composite; use Giza.Widget.Composite;
with Giza.Widget.Tiles;
with Giza.Widget.Button;
with Giza.Widget.Text;
use Giza.Widget;

package Giza.Widget.Keyboards is

   subtype Parent is Giza.Widget.Composite.Instance;
   type Instance is new Parent with private;
   subtype Class is Instance'Class;
   type Ref is access all Class;

   procedure On_Init (This : in out Instance);

   overriding
   procedure Draw (This  : in out Instance;
                   Ctx   : in out Context.Class;
                   Force : Boolean := True);

   overriding
   function On_Position_Event
     (This  : in out Instance;
      Evt   : Position_Event_Ref;
      Pos   : Point_T) return Boolean;

   procedure Set_Max_Entry_Length (This : in out Instance; Len : Natural);
   function Get_Text (This : Instance) return String;

private

   type Button_Type is
     (Btn_1, Btn_2, Btn_3, Btn_4, Btn_5, Btn_6, Btn_7, Btn_8, Btn_9, Btn_0,
      Btn_Q, Btn_W, Btn_E, Btn_R, Btn_T, Btn_Y, Btn_U, Btn_I, Btn_O, Btn_P,
      Btn_Caps, Btn_A, Btn_S, Btn_D, Btn_F, Btn_G, Btn_H, Btn_J, Btn_K, Btn_L,
      Btn_Nothing, Btn_Z, Btn_X, Btn_C, Btn_V, Btn_B, Btn_N, Btn_M, Btn_Del,
      Btn_Return, Btn_Special, Btn_Space, Btn_OK);

   type Button_Pos_Type is record
      Line, Row : Natural;
   end record;

   Button_To_Pos : constant array (Button_Type) of Button_Pos_Type :=
     (Btn_1 => (1, 1), Btn_2 => (1, 2), Btn_3 => (1, 3), Btn_4 => (1, 4),
      Btn_5 => (1, 5), Btn_6 => (1, 6), Btn_7 => (1, 7), Btn_8 => (1, 8),
      Btn_9 => (1, 9), Btn_0 => (1, 10),

      Btn_Q => (2, 1), Btn_W => (2, 2), Btn_E => (2, 3), Btn_R => (2, 4),
      Btn_T => (2, 5), Btn_Y => (2, 6), Btn_U => (2, 7), Btn_I => (2, 8),
      Btn_O => (2, 9), Btn_P => (2, 10),

      Btn_Caps => (3, 1), Btn_A => (3, 2), Btn_S => (3, 3), Btn_D => (3, 4),
      Btn_F => (3, 5), Btn_G => (3, 6), Btn_H => (3, 7), Btn_J => (3, 8),
      Btn_K => (3, 9), Btn_L => (3, 10),

      Btn_Nothing => (4, 1), Btn_Z => (4, 2), Btn_X => (4, 3), Btn_C => (4, 4),
      Btn_V => (4, 5), Btn_B => (4, 6), Btn_N => (4, 7), Btn_M => (4, 8),
      Btn_Del => (4, 9), Btn_Return => (4, 10),
      Btn_Special => (5, 1), Btn_Space => (5, 2), Btn_OK => (5, 3));

   type Tiles_10_Array is array (Integer range <>) of
     aliased Tiles.Instance (10, Tiles.Left_Right);
   type Gbutton_Array is array (Button_Type) of
     aliased Button.Instance;

   type Instance is new Parent with record
      Initialised  : Boolean := False;
      Max_Text_Len : Natural := 100;
      Text_Display : aliased Text.Instance;
      Cursor       : Natural;
      Root         : aliased Tiles.Instance (5, Tiles.Top_Down);
      Lines        : Tiles_10_Array (1 .. 4);
      Last_Line    : aliased Tiles.Instance (3, Tiles.Left_Right);
      Buttons      : Gbutton_Array;
      Caps         : Boolean := False;
      Special      : Boolean := False;
   end record;

end Giza.Widget.Keyboards;
