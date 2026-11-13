package body Input_Validator with SPARK_Mode => On is
   procedure Copy_Valid (Input : String; Result : out Validation_Result) is
   begin
      Result := (Accepted => True, Length => Input'Length,
                 Data => [others => ' ']);
      Result.Data (1 .. Result.Length) := Input;
   end Copy_Valid;

   procedure Validate (Input : String; Result : out Validation_Result) is
   begin
      if Meets_Policy (Input) then
         Copy_Valid (Input, Result);
      else
         Result := (Accepted => False, Length => 0,
                    Data => [others => ' ']);
      end if;
   end Validate;
end Input_Validator;
