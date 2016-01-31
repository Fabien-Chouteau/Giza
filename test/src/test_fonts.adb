with Giza.Colors; use Giza.Colors;

with Giza.Bitmap_Fonts.FreeMono12pt7b;
with Giza.Bitmap_Fonts.FreeMono18pt7b;
with Giza.Bitmap_Fonts.FreeMono24pt7b;
with Giza.Bitmap_Fonts.FreeMono32pt7b;
with Giza.Bitmap_Fonts.FreeMono8pt7b;
with Giza.Bitmap_Fonts.FreeMonoBold12pt7b;
with Giza.Bitmap_Fonts.FreeMonoBold18pt7b;
with Giza.Bitmap_Fonts.FreeMonoBold24pt7b;
with Giza.Bitmap_Fonts.FreeMonoBold32pt7b;
with Giza.Bitmap_Fonts.FreeMonoBold8pt7b;
with Giza.Bitmap_Fonts.FreeMonoBoldOblique12pt7b;
with Giza.Bitmap_Fonts.FreeMonoBoldOblique18pt7b;
with Giza.Bitmap_Fonts.FreeMonoBoldOblique24pt7b;
with Giza.Bitmap_Fonts.FreeMonoBoldOblique32pt7b;
with Giza.Bitmap_Fonts.FreeMonoBoldOblique8pt7b;
with Giza.Bitmap_Fonts.FreeMonoOblique12pt7b;
with Giza.Bitmap_Fonts.FreeMonoOblique18pt7b;
with Giza.Bitmap_Fonts.FreeMonoOblique24pt7b;
with Giza.Bitmap_Fonts.FreeMonoOblique32pt7b;
with Giza.Bitmap_Fonts.FreeMonoOblique8pt7b;
with Giza.Bitmap_Fonts.FreeSans12pt7b;
with Giza.Bitmap_Fonts.FreeSans18pt7b;
with Giza.Bitmap_Fonts.FreeSans24pt7b;
with Giza.Bitmap_Fonts.FreeSans32pt7b;
with Giza.Bitmap_Fonts.FreeSans8pt7b;
with Giza.Bitmap_Fonts.FreeSansBold12pt7b;
with Giza.Bitmap_Fonts.FreeSansBold18pt7b;
with Giza.Bitmap_Fonts.FreeSansBold24pt7b;
with Giza.Bitmap_Fonts.FreeSansBold32pt7b;
with Giza.Bitmap_Fonts.FreeSansBold8pt7b;
with Giza.Bitmap_Fonts.FreeSansBoldOblique12pt7b;
with Giza.Bitmap_Fonts.FreeSansBoldOblique18pt7b;
with Giza.Bitmap_Fonts.FreeSansBoldOblique24pt7b;
with Giza.Bitmap_Fonts.FreeSansBoldOblique32pt7b;
with Giza.Bitmap_Fonts.FreeSansBoldOblique8pt7b;
with Giza.Bitmap_Fonts.FreeSansOblique12pt7b;
with Giza.Bitmap_Fonts.FreeSansOblique18pt7b;
with Giza.Bitmap_Fonts.FreeSansOblique24pt7b;
with Giza.Bitmap_Fonts.FreeSansOblique32pt7b;
with Giza.Bitmap_Fonts.FreeSansOblique8pt7b;
with Giza.Bitmap_Fonts.FreeSerif12pt7b;
with Giza.Bitmap_Fonts.FreeSerif18pt7b;
with Giza.Bitmap_Fonts.FreeSerif24pt7b;
with Giza.Bitmap_Fonts.FreeSerif32pt7b;
with Giza.Bitmap_Fonts.FreeSerif8pt7b;
with Giza.Bitmap_Fonts.FreeSerifBold12pt7b;
with Giza.Bitmap_Fonts.FreeSerifBold18pt7b;
with Giza.Bitmap_Fonts.FreeSerifBold24pt7b;
with Giza.Bitmap_Fonts.FreeSerifBold32pt7b;
with Giza.Bitmap_Fonts.FreeSerifBold8pt7b;
with Giza.Bitmap_Fonts.FreeSerifBoldItalic12pt7b;
with Giza.Bitmap_Fonts.FreeSerifBoldItalic18pt7b;
with Giza.Bitmap_Fonts.FreeSerifBoldItalic24pt7b;
with Giza.Bitmap_Fonts.FreeSerifBoldItalic32pt7b;
with Giza.Bitmap_Fonts.FreeSerifBoldItalic8pt7b;
with Giza.Bitmap_Fonts.FreeSerifItalic12pt7b;
with Giza.Bitmap_Fonts.FreeSerifItalic18pt7b;
with Giza.Bitmap_Fonts.FreeSerifItalic24pt7b;
with Giza.Bitmap_Fonts.FreeSerifItalic32pt7b;
with Giza.Bitmap_Fonts.FreeSerifItalic8pt7b;

with Giza.Hershey_Fonts.Astrology;
with Giza.Hershey_Fonts.Cursive;
with Giza.Hershey_Fonts.Cyrilc_1;
with Giza.Hershey_Fonts.Cyrillic;
with Giza.Hershey_Fonts.Futural;
with Giza.Hershey_Fonts.Futuram;
with Giza.Hershey_Fonts.Gothgbt;
with Giza.Hershey_Fonts.Gothgrt;
with Giza.Hershey_Fonts.Gothiceng;
with Giza.Hershey_Fonts.Gothicger;
with Giza.Hershey_Fonts.Gothicita;
with Giza.Hershey_Fonts.Gothitt;
with Giza.Hershey_Fonts.Greek;
with Giza.Hershey_Fonts.Greekc;
with Giza.Hershey_Fonts.Greeks;
with Giza.Hershey_Fonts.Japanese;
with Giza.Hershey_Fonts.Markers;
with Giza.Hershey_Fonts.Mathlow;
with Giza.Hershey_Fonts.Mathupp;
with Giza.Hershey_Fonts.Meteorology;
with Giza.Hershey_Fonts.Music;
with Giza.Hershey_Fonts.Rowmand;
with Giza.Hershey_Fonts.Rowmans;
with Giza.Hershey_Fonts.Rowmant;
with Giza.Hershey_Fonts.Scriptc;
with Giza.Hershey_Fonts.Scripts;
with Giza.Hershey_Fonts.Symbolic;
with Giza.Hershey_Fonts.Timesg;
with Giza.Hershey_Fonts.Timesi;
with Giza.Hershey_Fonts.Timesib;
with Giza.Hershey_Fonts.Timesr;

with Giza.Fonts; use Giza.Fonts;

package body Test_Fonts is

   type Font_Ref_Array is array (Integer range <>) of Font_Ref;

   The_Fonts : constant Font_Ref_Array :=
     (Giza.Bitmap_Fonts.FreeMono12pt7b.Font,
      Giza.Bitmap_Fonts.FreeMono18pt7b.Font,
      Giza.Bitmap_Fonts.FreeMono24pt7b.Font,
      Giza.Bitmap_Fonts.FreeMono32pt7b.Font,
      Giza.Bitmap_Fonts.FreeMono8pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoBold12pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoBold18pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoBold24pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoBold32pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoBold8pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoBoldOblique12pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoBoldOblique18pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoBoldOblique24pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoBoldOblique32pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoBoldOblique8pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoOblique12pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoOblique18pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoOblique24pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoOblique32pt7b.Font,
      Giza.Bitmap_Fonts.FreeMonoOblique8pt7b.Font,
      Giza.Bitmap_Fonts.FreeSans12pt7b.Font,
      Giza.Bitmap_Fonts.FreeSans18pt7b.Font,
      Giza.Bitmap_Fonts.FreeSans24pt7b.Font,
      Giza.Bitmap_Fonts.FreeSans32pt7b.Font,
      Giza.Bitmap_Fonts.FreeSans8pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansBold12pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansBold18pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansBold24pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansBold32pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansBold8pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansBoldOblique12pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansBoldOblique18pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansBoldOblique24pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansBoldOblique32pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansBoldOblique8pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansOblique12pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansOblique18pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansOblique24pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansOblique32pt7b.Font,
      Giza.Bitmap_Fonts.FreeSansOblique8pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerif12pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerif18pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerif24pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerif32pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerif8pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifBold12pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifBold18pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifBold24pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifBold32pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifBold8pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifBoldItalic12pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifBoldItalic18pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifBoldItalic24pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifBoldItalic32pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifBoldItalic8pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifItalic12pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifItalic18pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifItalic24pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifItalic32pt7b.Font,
      Giza.Bitmap_Fonts.FreeSerifItalic8pt7b.Font,
      Giza.Hershey_Fonts.Astrology.Font,
      Giza.Hershey_Fonts.Cursive.Font,
      Giza.Hershey_Fonts.Cyrilc_1.Font,
      Giza.Hershey_Fonts.Cyrillic.Font,
      Giza.Hershey_Fonts.Futural.Font,
      Giza.Hershey_Fonts.Futuram.Font,
      Giza.Hershey_Fonts.Gothgbt.Font,
      Giza.Hershey_Fonts.Gothgrt.Font,
      Giza.Hershey_Fonts.Gothiceng.Font,
      Giza.Hershey_Fonts.Gothicger.Font,
      Giza.Hershey_Fonts.Gothicita.Font,
      Giza.Hershey_Fonts.Gothitt.Font,
      Giza.Hershey_Fonts.Greek.Font,
      Giza.Hershey_Fonts.Greekc.Font,
      Giza.Hershey_Fonts.Greeks.Font,
      Giza.Hershey_Fonts.Japanese.Font,
      Giza.Hershey_Fonts.Markers.Font,
      Giza.Hershey_Fonts.Mathlow.Font,
      Giza.Hershey_Fonts.Mathupp.Font,
      Giza.Hershey_Fonts.Meteorology.Font,
      Giza.Hershey_Fonts.Music.Font,
      Giza.Hershey_Fonts.Rowmand.Font,
      Giza.Hershey_Fonts.Rowmans.Font,
      Giza.Hershey_Fonts.Rowmant.Font,
      Giza.Hershey_Fonts.Scriptc.Font,
      Giza.Hershey_Fonts.Scripts.Font,
      Giza.Hershey_Fonts.Symbolic.Font,
      Giza.Hershey_Fonts.Timesg.Font,
      Giza.Hershey_Fonts.Timesi.Font,
      Giza.Hershey_Fonts.Timesib.Font,
      Giza.Hershey_Fonts.Timesr.Font);

   function Font_Name (Index : Integer) return String;

   ---------------
   -- Font_Name --
   ---------------

   function Font_Name (Index : Integer) return String is
      Offset : constant Integer := Index - The_Fonts'First;
   begin
      case Offset is
         when 0 => return "Bitmap FreeMono12pt7b";
         when 1 => return "Bitmap FreeMono18pt7b";
         when 2 => return "Bitmap FreeMono24pt7b";
         when 3 => return "Bitmap FreeMono32pt7b";
         when 4 => return "Bitmap FreeMono8pt7b";
         when 5 => return "Bitmap FreeMonoBold12pt7b";
         when 6 => return "Bitmap FreeMonoBold18pt7b";
         when 7 => return "Bitmap FreeMonoBold24pt7b";
         when 8 => return "Bitmap FreeMonoBold32pt7b";
         when 9 => return "Bitmap FreeMonoBold8pt7b";
         when 10 => return "Bitmap FreeMonoBoldOblique12pt7b";
         when 11 => return "Bitmap FreeMonoBoldOblique18pt7b";
         when 12 => return "Bitmap FreeMonoBoldOblique24pt7b";
         when 13 => return "Bitmap FreeMonoBoldOblique32pt7b";
         when 14 => return "Bitmap FreeMonoBoldOblique8pt7b";
         when 15 => return "Bitmap FreeMonoOblique12pt7b";
         when 16 => return "Bitmap FreeMonoOblique18pt7b";
         when 17 => return "Bitmap FreeMonoOblique24pt7b";
         when 18 => return "Bitmap FreeMonoOblique32pt7b";
         when 19 => return "Bitmap FreeMonoOblique8pt7b";
         when 20 => return "Bitmap FreeSans12pt7b";
         when 21 => return "Bitmap FreeSans18pt7b";
         when 22 => return "Bitmap FreeSans24pt7b";
         when 23 => return "Bitmap FreeSans32pt7b";
         when 24 => return "Bitmap FreeSans8pt7b";
         when 25 => return "Bitmap FreeSansBold12pt7b";
         when 26 => return "Bitmap FreeSansBold18pt7b";
         when 27 => return "Bitmap FreeSansBold24pt7b";
         when 28 => return "Bitmap FreeSansBold32pt7b";
         when 29 => return "Bitmap FreeSansBold8pt7b";
         when 30 => return "Bitmap FreeSansBoldOblique12pt7b";
         when 31 => return "Bitmap FreeSansBoldOblique18pt7b";
         when 32 => return "Bitmap FreeSansBoldOblique24pt7b";
         when 33 => return "Bitmap FreeSansBoldOblique32pt7b";
         when 34 => return "Bitmap FreeSansBoldOblique8pt7b";
         when 35 => return "Bitmap FreeSansOblique12pt7b";
         when 36 => return "Bitmap FreeSansOblique18pt7b";
         when 37 => return "Bitmap FreeSansOblique24pt7b";
         when 38 => return "Bitmap FreeSansOblique32pt7b";
         when 39 => return "Bitmap FreeSansOblique8pt7b";
         when 40 => return "Bitmap FreeSerif12pt7b";
         when 41 => return "Bitmap FreeSerif18pt7b";
         when 42 => return "Bitmap FreeSerif24pt7b";
         when 43 => return "Bitmap FreeSerif32pt7b";
         when 44 => return "Bitmap FreeSerif8pt7b";
         when 45 => return "Bitmap FreeSerifBold12pt7b";
         when 46 => return "Bitmap FreeSerifBold18pt7b";
         when 47 => return "Bitmap FreeSerifBold24pt7b";
         when 48 => return "Bitmap FreeSerifBold32pt7b";
         when 49 => return "Bitmap FreeSerifBold8pt7b";
         when 50 => return "Bitmap FreeSerifBoldItalic12pt7b";
         when 51 => return "Bitmap FreeSerifBoldItalic18pt7b";
         when 52 => return "Bitmap FreeSerifBoldItalic24pt7b";
         when 53 => return "Bitmap FreeSerifBoldItalic32pt7b";
         when 54 => return "Bitmap FreeSerifBoldItalic8pt7b";
         when 55 => return "Bitmap FreeSerifItalic12pt7b";
         when 56 => return "Bitmap FreeSerifItalic18pt7b";
         when 57 => return "Bitmap FreeSerifItalic24pt7b";
         when 58 => return "Bitmap FreeSerifItalic32pt7b";
         when 59 => return "Bitmap FreeSerifItalic8pt7b";
         when 60 => return "Hershey Astrology";
         when 61 => return "Hershey Cursive";
         when 62 => return "Hershey Cyrilc_1";
         when 63 => return "Hershey Cyrillic";
         when 64 => return "Hershey Futural";
         when 65 => return "Hershey Futuram";
         when 66 => return "Hershey Gothgbt";
         when 67 => return "Hershey Gothgrt";
         when 68 => return "Hershey Gothiceng";
         when 69 => return "Hershey Gothicger";
         when 70 => return "Hershey Gothicita";
         when 71 => return "Hershey Gothitt";
         when 72 => return "Hershey Greek";
         when 73 => return "Hershey Greekc";
         when 74 => return "Hershey Greeks";
         when 75 => return "Hershey Japanese";
         when 76 => return "Hershey Markers";
         when 77 => return "Hershey Mathlow";
         when 78 => return "Hershey Mathupp";
         when 79 => return "Hershey Meteorology";
         when 80 => return "Hershey Music";
         when 81 => return "Hershey Rowmand";
         when 82 => return "Hershey Rowmans";
         when 83 => return "Hershey Rowmant";
         when 84 => return "Hershey Scriptc";
         when 85 => return "Hershey Scripts";
         when 86 => return "Hershey Symbolic";
         when 87 => return "Hershey Timesg";
         when 88 => return "Hershey Timesi";
         when 89 => return "Hershey Timesib";
         when 90 => return "Hershey Timesr";
         when others => return "Unknown font...";
      end case;
   end Font_Name;

   -------------
   -- On_Init --
   -------------

   overriding procedure On_Init
     (This : in out Test_Fonts_Window)
   is
   begin
      On_Init (Test_Window (This));
      This.Boxes.Set_Toggle;
      This.Boxes.Set_Text ("Boxes");
      This.Next.Set_Text ("Next");
      This.Prev.Set_Text ("Prev");
      This.Tile.Set_Size ((This.Get_Size.W, This.Get_Size.H / 10));

      This.Tile.Set_Child (1, This.Prev'Unchecked_Access);
      This.Tile.Set_Child (2, This.Boxes'Unchecked_Access);
      This.Tile.Set_Child (3, This.Next'Unchecked_Access);
      This.Add_Child (This.Tile'Unchecked_Access, (0, 0));

      This.Font_Index := The_Fonts'First;
   end On_Init;

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (This : in out Test_Fonts_Window;
      Ctx : in out Context'Class;
      Force : Boolean := True)
   is
      pragma Unreferenced (Force);
      procedure Draw_Glyph_And_Values (Str  : String;
                                       Font : Font_Ref;
                                       Pt   : Point_T);

      -----------------------
      -- Draw_Glyph_Values --
      -----------------------

      procedure Draw_Glyph_And_Values (Str  : String;
                                       Font : Font_Ref;
                                       Pt   : Point_T)
      is
         Width, Height, X_Advance : Natural;
         X_Offset, Y_Offset : Integer;
         Org, Next : Point_T;
      begin
         Next := Pt;
         for C of Str loop
            Org := Next;
            Ctx.Move_To (Org);
            Font.Glyph_Box (C, Width, Height, X_Advance, X_Offset, Y_Offset);
            Ctx.Set_Color (Black);
            Font.Print_Glyph (Ctx, C);
            Next := Ctx.Position;

            if This.Boxes.Active then
               Ctx.Set_Color (Blue);
               Ctx.Rectangle
                 ((Org + Point_T'(X_Offset, Y_Offset), (Width, Height)));

               Ctx.Set_Color (Green);
               Ctx.Move_To (Org);
               Ctx.Line_To (Org + Point_T'(X_Advance, 0));

               Ctx.Set_Color (Red);
               Ctx.Move_To (Org);
               Ctx.Line_To (Org + Point_T'(X_Offset, 0));

               Ctx.Set_Color (Yellow);
               Ctx.Move_To (Org);
               Ctx.Line_To (Org + Point_T'(0, Y_Offset));
            end if;
         end loop;
      end Draw_Glyph_And_Values;

      Bounds : constant Rect_T := ((0, This.Get_Size.H / 10),
                                   This.Get_Size - (0, This.Get_Size.H / 10));
      Pt1 : constant Point_T := Bounds.Org + Point_T'(5, 20);
      Pt2 : constant Point_T := Pt1 + Point_T'(0, 40);
      Pt3 : constant Point_T := Pt2 + Point_T'(0, 40);

      Str : constant String := "C'est un Test!";
      Str2 : constant String := "Box Test";
      Str3 : constant String := "Long string with a lot of split points and" &
        ASCII.LF & "this one was forced (ASCII.LF)..." &
        " A B C D E F G H I J K L M N O P Q R S T U V W X Y Z" &
        "abcdefghijklmnopqrstuvwxyz" & ASCII.LF &
        "1234567890`~!@#$%^&*()-_=+[]{};:'""<>,.";
      Rect : Rect_T;
   begin
      Ctx.Set_Color (White);
      Ctx.Fill_Rectangle (Bounds);

      --  Print Font's name
      Ctx.Move_To (Pt2);
      Ctx.Set_Font (Giza.Bitmap_Fonts.FreeMono8pt7b.Font);
      Ctx.Set_Color (Black);
      Ctx.Print (Font_Name (This.Font_Index));

      --  Set selected font
      Ctx.Set_Font (The_Fonts (This.Font_Index));

      --  Test box
      Ctx.Move_To (Pt3);
      Ctx.Set_Font (Giza.Bitmap_Fonts.FreeMono8pt7b.Font);
      Ctx.Box (Str       => Str2,
               Rect      => Rect,
               Max_Width => This.Get_Size.W);
      Ctx.Set_Color (Red);
      Ctx.Rectangle (Pt3 + Rect);
      Ctx.Set_Color (Black);
      Ctx.Move_To (Pt3);
      Ctx.Print (Str2);

      Draw_Glyph_And_Values (Str, The_Fonts (This.Font_Index), Pt1);

      Ctx.Set_Color (Black);
      Ctx.Set_Font (The_Fonts (This.Font_Index));
      Ctx.Print_In_Rect (Str3, Bounds);

      Draw (Test_Window (This), Ctx, Force => True);
   end Draw;

   -----------------------
   -- On_Position_Event --
   -----------------------

   overriding function On_Position_Event
     (This : in out Test_Fonts_Window;
      Evt  : Position_Event_Ref;
      Pos  : Point_T) return Boolean
   is
   begin
      if On_Position_Event (Parent (This), Evt, Pos) then
         if This.Next.Active then
            if This.Font_Index = The_Fonts'Last then
               This.Font_Index := The_Fonts'First;
            else
               This.Font_Index := This.Font_Index + 1;
            end if;
         elsif This.Prev.Active then
            if This.Font_Index = The_Fonts'First then
               This.Font_Index := The_Fonts'Last;
            else
               This.Font_Index := This.Font_Index - 1;
            end if;
         end if;
         return True;
      else
         return False;
      end if;
   end On_Position_Event;

end Test_Fonts;
