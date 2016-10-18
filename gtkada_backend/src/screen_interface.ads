with Screen_Parameters; use Screen_Parameters;
with Giza.Colors;
with Giza.Types; use Giza.Types;
with Giza.Backend;
use Giza;

package Screen_Interface is

   subtype Parent is Backend.Instance;
   type GTKada_Backend is new Parent with record
      Enabled : Boolean := True;
   end record;

   overriding
   function Has_Double_Buffring (This : GTKada_Backend) return Boolean is
     (False);

   overriding
   procedure Set_Pixel (This : in out GTKada_Backend;
                        Pt : Point_T);

   overriding
   procedure Set_Color
     (This : in out GTKada_Backend;
      C : Giza.Colors.Color);

   overriding
   function Size (This : GTKada_Backend) return Size_T;

   procedure Enable (This : in out GTKada_Backend);
   procedure Disable (This : in out GTKada_Backend);

   function Create return access GTKada_Backend is (new GTKada_Backend);

   subtype Color  is Screen_Parameters.Color;
   subtype Width  is Screen_Parameters.Width;
   subtype Height is Screen_Parameters.Height;

   type Touch_State is record
      Touch_Detected : Boolean;
      X : Width;
      Y : Height;
   end record;

   type Point is record
      X : Width;
      Y : Height;
   end record;

   function "+" (P1, P2 : Point) return Point is (P1.X + P2.X, P1.Y + P2.Y);
   function "-" (P1, P2 : Point) return Point is (P1.X - P2.X, P1.Y - P2.Y);

   procedure Initialize;
   --  Initialize the screen backend

   function  Get_Touch_State return Touch_State;
   --  Get touch screen information

   procedure Set_Pixel (P : Point; Col : Color);
   --  Set color of one pixel

   procedure Fill_Screen (Col : Color);
   --  Set color of every pixels on screen

   type RGB_Component is new Natural range 0 .. 255;
   function RGB_To_Color (R, G, B : RGB_Component) return Color
     with Inline_Always;

--     --  Predefined colors
--
--  function Dark_Red           return Color is (RGB_To_Color (139,   0,   0));
--  function Brown              return Color is (RGB_To_Color (165,  42,  42));
--  function Firebrick          return Color is (RGB_To_Color (178,  34,  34));
--  function Crimson            return Color is (RGB_To_Color (220,  20,  60));
--  function Red                return Color is (RGB_To_Color (255,   0,   0));
--  function Tomato             return Color is (RGB_To_Color (255,  99,  71));
--  function Coral              return Color is (RGB_To_Color (255, 127,  80));
--  function Indian_Red         return Color is (RGB_To_Color (205,  92,  92));
--  function Light_Coral        return Color is (RGB_To_Color (240, 128, 128));
--  function Dark_Salmon        return Color is (RGB_To_Color (233, 150, 122));
--  function Salmon             return Color is (RGB_To_Color (250, 128, 114));
--  function Light_Salmon       return Color is (RGB_To_Color (255, 160, 122));
--  function Orange_Red         return Color is (RGB_To_Color (255,  69,   0));
--  function Dark_Orange        return Color is (RGB_To_Color (255, 140,   0));
--  function Orange             return Color is (RGB_To_Color (255, 165,   0));
--  function Gold               return Color is (RGB_To_Color (255, 215,   0));
--  function Dark_Golden_Rod    return Color is (RGB_To_Color (184, 134,  11));
--  function Golden_Rod         return Color is (RGB_To_Color (218, 165,  32));
--  function Pale_Golden_Rod    return Color is (RGB_To_Color (238, 232, 170));
--  function Dark_Khaki         return Color is (RGB_To_Color (189, 183, 107));
--  function Khaki              return Color is (RGB_To_Color (240, 230, 140));
--  function Olive              return Color is (RGB_To_Color (128, 128,   0));
--  function Yellow             return Color is (RGB_To_Color (255, 255,   0));
--  function Yellow_Green       return Color is (RGB_To_Color (154, 205,  50));
--  function Dark_Olive_Green   return Color is (RGB_To_Color ( 85, 107,  47));
--  function Olive_Drab         return Color is (RGB_To_Color (107, 142,  35));
--  function Lawn_Green         return Color is (RGB_To_Color (124, 252,   0));
--  function Chart_Reuse        return Color is (RGB_To_Color (127, 255,   0));
--  function Green_Yellow       return Color is (RGB_To_Color (173, 255,  47));
--  function Dark_Green         return Color is (RGB_To_Color (  0, 100,   0));
--  function Green              return Color is (RGB_To_Color (  0, 128,   0));
--  function Maroon             return Color is (RGB_To_Color (128,   0,   0));
--  function Forest_Green       return Color is (RGB_To_Color ( 34, 139,  34));
--  function Lime               return Color is (RGB_To_Color (  0, 255,   0));
--  function Lime_Green         return Color is (RGB_To_Color ( 50, 205,  50));
--  function Light_Green        return Color is (RGB_To_Color (144, 238, 144));
--  function Pale_Green         return Color is (RGB_To_Color (152, 251, 152));
--  function Dark_Sea_Green     return Color is (RGB_To_Color (143, 188, 143));
--  function Medium_Spring_Greenreturn Color is (RGB_To_Color (  0, 250, 154));
--  function Spring_Green       return Color is (RGB_To_Color (  0, 255, 127));
--  function Sea_Green          return Color is (RGB_To_Color ( 46, 139,  87));
--  function Medium_Aqua_Marine return Color is (RGB_To_Color (102, 205, 170));
--  function Medium_Sea_Green   return Color is (RGB_To_Color ( 60, 179, 113));
--  function Light_Sea_Green    return Color is (RGB_To_Color ( 32, 178, 170));
--  function Dark_Slate_Gray    return Color is (RGB_To_Color ( 47,  79,  79));
--  function Teal               return Color is (RGB_To_Color (  0, 128, 128));
--  function Dark_Cyan          return Color is (RGB_To_Color (  0, 139, 139));
--  function Aqua               return Color is (RGB_To_Color (  0, 255, 255));
--  function Cyan               return Color is (RGB_To_Color (  0, 255, 255));
--  function Light_Cyan         return Color is (RGB_To_Color (224, 255, 255));
--  function Dark_Turquoise     return Color is (RGB_To_Color (  0, 206, 209));
--  function Turquoise          return Color is (RGB_To_Color ( 64, 224, 208));
--  function Medium_Turquoise   return Color is (RGB_To_Color ( 72, 209, 204));
--  function Pale_Turquoise     return Color is (RGB_To_Color (175, 238, 238));
--  function Aqua_Marine        return Color is (RGB_To_Color (127, 255, 212));
--  function Powder_Blue        return Color is (RGB_To_Color (176, 224, 230));
--  function Cadet_Blue         return Color is (RGB_To_Color ( 95, 158, 160));
--  function Steel_Blue         return Color is (RGB_To_Color ( 70, 130, 180));
--  function Corn_Flower_Blue   return Color is (RGB_To_Color (100, 149, 237));
--  function Deep_Sky_Blue      return Color is (RGB_To_Color (  0, 191, 255));
--  function Dodger_Blue        return Color is (RGB_To_Color ( 30, 144, 255));
--  function Light_Blue         return Color is (RGB_To_Color (173, 216, 230));
--  function Sky_Blue           return Color is (RGB_To_Color (135, 206, 235));
--  function Light_Sky_Blue     return Color is (RGB_To_Color (135, 206, 250));
--  function Midnight_Blue      return Color is (RGB_To_Color ( 25,  25, 112));
--  function Navy               return Color is (RGB_To_Color (  0,   0, 128));
--  function Dark_Blue          return Color is (RGB_To_Color (  0,   0, 139));
--  function Medium_Blue        return Color is (RGB_To_Color (  0,   0, 205));
--  function Blue               return Color is (RGB_To_Color (  0,   0, 255));
--  function Royal_Blue         return Color is (RGB_To_Color ( 65, 105, 225));
--  function Blue_Violet        return Color is (RGB_To_Color (138,  43, 226));
--  function Indigo             return Color is (RGB_To_Color ( 75,   0, 130));
--  function Dark_Slate_Blue    return Color is (RGB_To_Color ( 72,  61, 139));
--  function Slate_Blue         return Color is (RGB_To_Color (106,  90, 205));
--  function Medium_Slate_Blue  return Color is (RGB_To_Color (123, 104, 238));
--  function Medium_Purple      return Color is (RGB_To_Color (147, 112, 219));
--  function Dark_Magenta       return Color is (RGB_To_Color (139,   0, 139));
--  function Dark_Violet        return Color is (RGB_To_Color (148,   0, 211));
--  function Dark_Orchid        return Color is (RGB_To_Color (153,  50, 204));
--  function Medium_Orchid      return Color is (RGB_To_Color (186,  85, 211));
--  function Purple             return Color is (RGB_To_Color (128,   0, 128));
--  function Thistle            return Color is (RGB_To_Color (216, 191, 216));
--  function Plum               return Color is (RGB_To_Color (221, 160, 221));
--  function Violet             return Color is (RGB_To_Color (238, 130, 238));
--  function Magenta            return Color is (RGB_To_Color (255,   0, 255));
--  function Orchid             return Color is (RGB_To_Color (218, 112, 214));
--  function Medium_Violet_Red  return Color is (RGB_To_Color (199,  21, 133));
--  function Pale_Violet_Red    return Color is (RGB_To_Color (219, 112, 147));
--  function Deep_Pink          return Color is (RGB_To_Color (255,  20, 147));
--  function Hot_Pink           return Color is (RGB_To_Color (255, 105, 180));
--  function Light_Pink         return Color is (RGB_To_Color (255, 182, 193));
--  function Pink               return Color is (RGB_To_Color (255, 192, 203));
--  function Antique_White      return Color is (RGB_To_Color (250, 235, 215));
--  function Beige              return Color is (RGB_To_Color (245, 245, 220));
--  function Bisque             return Color is (RGB_To_Color (255, 228, 196));
--  function Blanched_Almond    return Color is (RGB_To_Color (255, 235, 205));
--  function Wheat              return Color is (RGB_To_Color (245, 222, 179));
--  function Corn_Silk          return Color is (RGB_To_Color (255, 248, 220));
--  function Lemon_Chiffon      return Color is (RGB_To_Color (255, 250, 205));
--  function Light_Yellow       return Color is (RGB_To_Color (255, 255, 224));
--  function Saddle_Brown       return Color is (RGB_To_Color (139,  69,  19));
--  function Sienna             return Color is (RGB_To_Color (160,  82,  45));
--  function Chocolate          return Color is (RGB_To_Color (210, 105,  30));
--  function Peru               return Color is (RGB_To_Color (205, 133,  63));
--  function Sandy_Brown        return Color is (RGB_To_Color (244, 164,  96));
--  function Burly_Wood         return Color is (RGB_To_Color (222, 184, 135));
--  function Tan                return Color is (RGB_To_Color (210, 180, 140));
--  function Rosy_Brown         return Color is (RGB_To_Color (188, 143, 143));
--  function Moccasin           return Color is (RGB_To_Color (255, 228, 181));
--  function Navajo_White       return Color is (RGB_To_Color (255, 222, 173));
--  function Peach_Puff         return Color is (RGB_To_Color (255, 218, 185));
--  function Misty_Rose         return Color is (RGB_To_Color (255, 228, 225));
--  function Lavender_Blush     return Color is (RGB_To_Color (255, 240, 245));
--  function Linen              return Color is (RGB_To_Color (250, 240, 230));
--  function Old_Lace           return Color is (RGB_To_Color (253, 245, 230));
--  function Papaya_Whip        return Color is (RGB_To_Color (255, 239, 213));
--  function Sea_Shell          return Color is (RGB_To_Color (255, 245, 238));
--  function Mint_Cream         return Color is (RGB_To_Color (245, 255, 250));
--  function Slate_Gray         return Color is (RGB_To_Color (112, 128, 144));
--  function Light_Slate_Gray   return Color is (RGB_To_Color (119, 136, 153));
--  function Light_Steel_Blue   return Color is (RGB_To_Color (176, 196, 222));
--  function Lavender           return Color is (RGB_To_Color (230, 230, 250));
--  function Floral_White       return Color is (RGB_To_Color (255, 250, 240));
--  function Alice_Blue         return Color is (RGB_To_Color (240, 248, 255));
--  function Ghost_White        return Color is (RGB_To_Color (248, 248, 255));
--  function Honeydew           return Color is (RGB_To_Color (240, 255, 240));
--  function Ivory              return Color is (RGB_To_Color (255, 255, 240));
--  function Azure              return Color is (RGB_To_Color (240, 255, 255));
--  function Snow               return Color is (RGB_To_Color (255, 250, 250));
--  function Black              return Color is (RGB_To_Color (  0,   0,   0));
--  function Dim_Grey           return Color is (RGB_To_Color (105, 105, 105));
--  function Grey               return Color is (RGB_To_Color (128, 128, 128));
--  function Dark_Grey          return Color is (RGB_To_Color (169, 169, 169));
--  function Silver             return Color is (RGB_To_Color (192, 192, 192));
--  function Light_Grey         return Color is (RGB_To_Color (211, 211, 211));
--  function Gainsboro          return Color is (RGB_To_Color (220, 220, 220));
--  function White_Smoke        return Color is (RGB_To_Color (245, 245, 245));
--  function White              return Color is (RGB_To_Color (255, 255, 255));

end Screen_Interface;
