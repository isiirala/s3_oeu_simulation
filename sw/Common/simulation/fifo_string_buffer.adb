
package body Fifo_String_Buffer is


-- The following implementation of protected body could be separate
   protected body Obj_Buffer is

      procedure Write(Data : in String) is
         use type Ada.Strings.Unbounded.Unbounded_String;
      begin

         if Data_Buffer = Ada.Strings.Unbounded.Null_Unbounded_String then
            Data_Buffer := Ada.Strings.Unbounded.To_Unbounded_String(Data);
         else
            Ada.Strings.Unbounded.Append(
              Source   => Data_Buffer,
              New_Item => Data);
         end if;
      end Write;

      procedure Read(Data : in out String; Actual_Len : out Natural) is
        Buff_Len         : Natural     :=
          Ada.Strings.Unbounded.Length(Data_Buffer);
        Data_Len         : Natural     := Data'Length;
        Len_To_Read      : Natural     := 0;
      begin

        if Data_Len < Buff_Len then
           Len_To_Read := Data_Len;
        else
           Len_To_Read := Buff_Len;
        end if;
        Actual_Len  := Len_To_Read;

        Data(Data'First .. (Data'First + Len_To_Read - 1)) :=
          Ada.Strings.Unbounded.Slice(
            Source => Data_Buffer,
            Low    => 1,
            High   => Len_To_Read);

        Ada.Strings.Unbounded.Delete(
          Source  => Data_Buffer,
          From    => 1,
          Through => Len_To_Read);


      end Read;

--      procedure Change_Len(New_Len : in Natural) is
--      begin
--         Allowed_Len := New_Len;
--      end Change_Len;

   end Obj_Buffer;

end Fifo_String_Buffer;
