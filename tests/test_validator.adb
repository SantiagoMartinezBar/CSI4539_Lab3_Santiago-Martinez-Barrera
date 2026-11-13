with Ada.Text_IO;
with Input_Validator; use Input_Validator;

procedure Test_Validator is
   Result : Validation_Result;
   Shifted : constant String (17 .. 19) := "Ab9";
   Edge    : constant String (Integer'Last .. Integer'Last) := "Z";
begin
   Validate (Shifted, Result);
   pragma Assert (Result.Accepted and then Result.Data (1 .. 3) = "Ab9");
   Validate (Edge, Result);
   pragma Assert (Result.Accepted and then Result.Length = 1);
   Validate ("", Result);
   pragma Assert (not Result.Accepted and then Result.Length = 0);
   for N in 1 .. 102 loop
      Validate (String'(1 .. N => 'A'), Result);
      pragma Assert (Result.Accepted = (N <= Maximum_Length));
   end loop;
   for Code in 0 .. 255 loop
      declare
         C : constant Character := Character'Val (Code);
         Expected : constant Boolean :=
           C in 'a' .. 'z' or C in 'A' .. 'Z' or C in '0' .. '9'
           or C = '_' or C = '-' or C = '.';
      begin
         Validate (String'(1 => C), Result);
         pragma Assert (Result.Accepted = Expected);
         if not Expected then
            pragma Assert (Result.Length = 0);
            pragma Assert (for all Value of Result.Data => Value = ' ');
         end if;
      end;
   end loop;
   Ada.Text_IO.Put_Line
     ("PASS: 102 lengths, 256 byte values, empty and shifted-index strings");
end Test_Validator;
