-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Oeu_Simu
--  Unit Type           : Package Specification 
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Root OEU simulation package
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with Ada.Strings.Unbounded;


with Glib;

package Oeu_Simu is

   

   procedure vacio;
  
  
private

   protected type Fifo_String_Buffer is
      procedure Write(Data : in String);
      procedure Read(Data : in out String; Actual_Len : out Natural);
      
   private
      Data_Buffer   : Ada.Strings.Unbounded.Unbounded_String := 
        Ada.Strings.Unbounded.Null_Unbounded_String;
   end Fifo_String_Buffer;

 


--   null;


end Oeu_Simu;
