with Giza.Windows; use Giza.Windows;
with Giza.Widgets.Tiles; use Giza.Widgets.Tiles;
with Giza.Widgets.Button; use Giza.Widgets.Button;
with Giza.Events; use Giza.Events;
with Giza.Graphics; use Giza.Graphics;
with Giza.Widgets.Text; use Giza.Widgets.Text;

package Keyboard_Windows is

   subtype Parent is Giza.Windows.Window;
   type Keyboard_Window is new Parent with private;

   overriding
   procedure On_Init (This : in out Keyboard_Window);

   overriding
   procedure On_Displayed (This : in out Keyboard_Window);

   overriding
   procedure On_Hidden (This : in out Keyboard_Window);

   overriding
   function On_Position_Event
     (This  : in out Keyboard_Window;
      Evt   : Position_Event_Ref;
      Pos   : Point_T) return Boolean;

   procedure Set_Max_Entry_Length (This : in out Keyboard_Window);
   function Get_Text (This : Keyboard_Window) return String;
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

   type Gtile_10_Array is array (Integer range <>) of
     aliased Gtile (10, Left_Right);
   type Gbutton_Array is array (Button_Type) of
     aliased Gbutton;

   type Keyboard_Window is new Parent with record
      Max_Text_Len : Natural := 0;
      Text         : Character;
      Text_Display : aliased Gtext;
      Cursor       : Natural;
      Root         : aliased Gtile (5, Top_Down);
      Lines        : Gtile_10_Array (1 .. 4);
      Last_Line    : aliased Gtile (3, Left_Right);
      Buttons      : Gbutton_Array;
      Caps         : Boolean := False;
      Special      : Boolean := False;
   end record;

end Keyboard_Windows;
