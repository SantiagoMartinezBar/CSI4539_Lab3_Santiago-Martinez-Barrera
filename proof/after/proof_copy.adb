package body Proof_Copy with SPARK_Mode => On is
   procedure Copy (Size : Positive; Data : out Buffer) is
   begin
      Data := (others => ' ');
      Data (Size) := 'A';
   end Copy;
end Proof_Copy;
