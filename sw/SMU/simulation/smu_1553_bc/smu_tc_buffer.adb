

with Byte_Meta_Buffer;
with Debug_Log;


package body Smu_Tc_Buffer is


   package Pkg_Tc_Buffer is new Byte_Meta_Buffer
     (Meta_Buffer_Len    => 2 ** 6,
      Data_Buffer_Len    => 2 ** 14,
      User_Meta_Byte_Len => Smu_Data.Tc_Buffer_Meta_Byte_Len_C,
      Bytes_For_Data_Len => Basic_Types_I.One_Byte,
      Use_Protection     => True);
   -- Byte Metabuffer with room for 64 TCs of maximum length.


-- TODO: Is it necessary protection IN TC BUFFER?


   Tc_Buffer_Rt02  : Pkg_Tc_Buffer.Buffer_T;
   -- TC buffer for the RT 2: OEU Nominal

   Tc_Buffer_Rt18  : Pkg_Tc_Buffer.Buffer_T;
   -- TC buffer for the RT 18: OEU Redundant




   function Metadata_To_Raw (Meta : Smu_Data.Tc_Buffer_Metadata_T)
     return Pkg_Tc_Buffer.Meta_Raw_T
   is
      Local_Meta : Smu_Data.Tc_Buffer_Metadata_T := Meta;
      Local_Raw  : Pkg_Tc_Buffer.Meta_Raw_T;
      for Local_Raw'Address use Local_Meta'Address;
   begin
      return Local_Raw;
   end Metadata_To_Raw;

   function Raw_To_Metadata (Raw_Meta : Pkg_Tc_Buffer.Meta_Raw_T)
     return Smu_Data.Tc_Buffer_Metadata_T
   is
      Local_Raw  : Pkg_Tc_Buffer.Meta_Raw_T      := Raw_Meta;
      Local_Meta : Smu_Data.Tc_Buffer_Metadata_T;
      for Local_Meta'Address use Local_Raw'Address;
   begin
      return Local_Meta;
   end Raw_To_Metadata;




   procedure Init
   is
   begin
      Pkg_Tc_Buffer.New_Buffer (Tc_Buffer_Rt02);
      Pkg_Tc_Buffer.New_Buffer (Tc_Buffer_Rt18);
   end Init;


   procedure Append_Tc_Block
     (Rt_Id   : in Basic_Types_1553.Rt_Id_T;
      Sa_Id   : in Basic_Types_1553.Sa_Id_T;
      Raw_Tc  : in Basic_Types_I.Byte_Array_T)
   is
      use type Basic_Types_1553.Rt_Id_T;
      use type Pkg_Tc_Buffer.Buffer_Result_T;

      Metadata  : Smu_Data.Tc_Buffer_Metadata_T := Smu_Data.Tc_Buffer_Metadata_Default_C;
      Result    : Pkg_Tc_Buffer.Buffer_Result_T := Pkg_Tc_Buffer.Result_Ok;

   begin

-- Build the metadata structure
      Metadata.Sa_Id  := Basic_Types_I.Uint8_T (Sa_Id);

-- Insert the TC in the correct queue depending of the RT id
      if Rt_Id = 2 then

         Tc_Buffer_Rt02.Insert
           (Meta_Raw => Metadata_To_Raw (Metadata),
            Data_Raw => Raw_Tc,
            Result   => Result);

      elsif Rt_Id = 18 then

         Tc_Buffer_Rt18.Insert
           (Meta_Raw => Metadata_To_Raw (Metadata),
            Data_Raw => Raw_Tc,
            Result   => Result);
      else
         Debug_Log.Do_Log ("SMU_TC_Buffer.Append_Tc_Block Unknown RT: " &
           Basic_Types_1553.Rt_Id_T'Image (Rt_Id));
      end if;

      if Result /= Pkg_Tc_Buffer.Result_Ok then
         Debug_Log.Do_Log ("SMU_TC_Buffer.Append_Tc_Block Error inserting TC: " &
           Pkg_Tc_Buffer.Buffer_Result_T'Image (Result));
      end if;

   end Append_Tc_Block;

   procedure Retrieve_Tc_Block
     (Rt_Id      : in Basic_Types_1553.Rt_Id_T;
      Tc_Data    : out Smu_Data.Tc_Buffer_Data_T)
   is
      use type Basic_Types_1553.Rt_Id_T;
      use type Pkg_Tc_Buffer.Buffer_Result_T;

      Metadata_Raw   : Pkg_Tc_Buffer.Meta_Raw_T      := Pkg_Tc_Buffer.Null_Meta_Raw_C;
      Result         : Pkg_Tc_Buffer.Buffer_Result_T := Pkg_Tc_Buffer.Result_Ok;
   begin

-- Init output parameter to empty TC data
      Tc_Data.Last_Index := 0;

-- Get the first TC block from the correct queue depending of the RT id
      if Rt_Id = 2 then

         Pkg_Tc_Buffer.Retrieve
           (Buffer     => Tc_Buffer_Rt02,
            Data_Raw   => Tc_Data.Tc_Block,
            Last_Index => Tc_Data.Last_Index,
            Meta_Raw   => Metadata_Raw,
            Result     => Result);

         Tc_Data.Metadata := Raw_To_Metadata (Metadata_Raw);

      elsif Rt_Id = 18 then

         Pkg_Tc_Buffer.Retrieve
           (Buffer     => Tc_Buffer_Rt18,
            Data_Raw   => Tc_Data.Tc_Block,
            Last_Index => Tc_Data.Last_Index,
            Meta_Raw   => Metadata_Raw,
            Result     => Result);

         Tc_Data.Metadata := Raw_To_Metadata (Metadata_Raw);
      else
         Debug_Log.Do_Log ("SMU_TC_Buffer.Retrieve_Tc_Block Unknown RT: " &
           Basic_Types_1553.Rt_Id_T'Image (Rt_Id));
      end if;

-- If there is an error reset output TC block, and write log only if there is an error
-- different from the buffer empty
      if Result /= Pkg_Tc_Buffer.Result_Ok then
         Tc_Data.Last_Index := 0;

         if Result /= Pkg_Tc_Buffer.Result_Meta_Empty then
            Debug_Log.Do_Log ("SMU_TC_Buffer.Retrieve_Tc_Block Error retrieving TC: " &
              Pkg_Tc_Buffer.Buffer_Result_T'Image (Result));
         end if;
      end if;

   end Retrieve_Tc_Block;

end Smu_Tc_Buffer;
