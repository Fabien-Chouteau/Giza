with Basic_Test_Window; use Basic_Test_Window;
with Giza.Context; use Giza.Context;

package Test_Images is

   subtype Parent is Test_Window;
   type Images_Window is new Parent with private;
   type Images_Window_Ref is access all Images_Window;

   overriding
   procedure On_Displayed (This : in out Images_Window) is null;
   overriding
   procedure On_Hidden (This : in out Images_Window) is null;

   overriding
   procedure Draw (This  : in out Images_Window;
                   Ctx   : in out Giza.Context.Class;
                   Force : Boolean := True);

private
   type Images_Window is new Test_Window with null record;
end Test_Images;
