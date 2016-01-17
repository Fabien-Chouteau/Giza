with Cairo;
with Cairo.Image_Surface; use Cairo.Image_Surface;

package Screen_Parameters is
--     subtype Width is Natural range 0 .. 239;
--     subtype Height is Natural range 0 .. 319;
   subtype Width is Natural range 0 .. 319;
   subtype Height is Natural range 0 .. 239;
   subtype Color is ARGB32_Data;
end Screen_Parameters;
