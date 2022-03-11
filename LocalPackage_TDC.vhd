--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--                                                                                                                     --
--  __/\\\\\\\\\\\\\\\__/\\\\\\\\\\\\\\\__/\\\\\\\\\\\\_____/\\\\\\\\\\\__/\\\\\\\\\\\\\\\__/\\\_____________          --
--   _\///////\\\/////__\/\\\///////////__\/\\\////////\\\__\/////\\\///__\/\\\///////////__\/\\\_____________         --
--    _______\/\\\_______\/\\\_____________\/\\\______\//\\\_____\/\\\_____\/\\\_____________\/\\\_____________        --
--     _______\/\\\_______\/\\\\\\\\\\\_____\/\\\_______\/\\\_____\/\\\_____\/\\\\\\\\\\\_____\/\\\_____________       --
--      _______\/\\\_______\/\\\///////______\/\\\_______\/\\\_____\/\\\_____\/\\\///////______\/\\\_____________      --
--       _______\/\\\_______\/\\\_____________\/\\\_______\/\\\_____\/\\\_____\/\\\_____________\/\\\_____________     --
--        _______\/\\\_______\/\\\_____________\/\\\_______/\\\______\/\\\_____\/\\\_____________\/\\\_____________	   --
--         _______\/\\\_______\/\\\\\\\\\\\\\\\_\/\\\\\\\\\\\\/____/\\\\\\\\\\\_\/\\\\\\\\\\\\\\\_\/\\\\\\\\\\\\\\\_   --
--          _______\///________\///////////////__\////////////_____\///////////__\///////////////__\///////////////__  --
--                                                                                                                     --
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------




------------------------------ LIBRARY DECLARATION ------------------------------

------------ IEEE LIBRARY -----------
--! Standard IEEE library
library IEEE;
	--! Standard Logic Vector library
	use IEEE.STD_LOGIC_1164.all;
	--! Numeric library
	use IEEE.NUMERIC_STD.ALL;
--	--! Math operation over real number (not for implementation)
--	--use IEEE.MATH_REAL.all;
------------------------------------

------------ STD LIBRARY -----------
--! Standard
library STD;
--! Textual Input/Output (only in simulation)
	use STD.textio.all;
------------------------------------


-- ---------- XILINX LIBRARY ----------
-- --! Xilinx Unisim library
-- library UNISIM;
-- 	--! Xilinx Unisim VComponent library
-- 	use UNISIM.VComponents.all;
--
-- --! \brief Xilinx Parametric Macro library
-- --! \details To be correctly used in Vivado write auto_detect_xpm into tcl console.
-- library xpm;
-- 	--! Xilinx Parametric Macro VComponent library
-- 	use xpm.vcomponents.all;
-- ------------------------------------




package LocalPackage_TDC is

	
	function Compute_Num_DSP (

		
		num_tap_tdl		:	integer;
		bit_dsp	:	positive


	) return integer ;

--------------------------------------	
	
	function Sample_AsyncTapsTDL (

		
		type_tdl	:	string;
		
		num_tap_tdl		:	positive;
		
		bit_smp_tdl		:	positive;
		
		AsyncTaps_TDL		:	std_logic_vector
		
	) return std_logic_vector ;
	
----------------------------------------	
	
	procedure	X7S_Choose_AsyncTaps_TDL (

		
		type_tdl	:	string;															
		
		signal	CO_Taps	:	IN	STD_LOGIC_VECTOR;										
		signal	O_Taps	:	IN	STD_LOGIC_VECTOR;										
		
		signal	AsyncTaps_TDL	:	OUT	STD_LOGIC_VECTOR								
		

	);
	
	


end LocalPackage_TDC;


package body LocalPackage_TDC is


	function Compute_Num_DSP (

	
		num_tap_tdl		:	integer;
		bit_dsp	:	positive
		

	) return integer is

		 variable  num_dsp : integer;

	begin

		 num_dsp := integer(num_tap_tdl)/integer(bit_dsp);

		 if (integer(num_tap_tdl) mod integer(bit_dsp)) > 0 then
			 num_dsp := num_dsp + 1;
		 end if;

		 return integer(num_dsp);
	end function;
	
	----------------------------------------------------------------------------

	
	function Sample_AsyncTapsTDL (

		
		type_tdl		:	string;
		
		num_tap_tdl		:	positive;
		
		bit_smp_tdl		:	positive;
		
		AsyncTaps_TDL		:	std_logic_vector
		
	) return std_logic_vector is

		variable	step_tap_tdl		:	integer;
		
		variable	SampledTaps_TDL_tmp		:	std_logic_vector(bit_smp_tdl -1 downto 0);

	begin

	
		step_tap_tdl		:=	integer(num_tap_tdl)/integer(bit_smp_tdl);

		if step_tap_tdl = 0 then
			step_tap_tdl := 1;
		end if;

		
		if type_tdl = "C" then
			SampledTaps_TDL_tmp	:= (Others => '0');

		elsif type_tdl = "O"  then
			SampledTaps_TDL_tmp	:= (Others => '1');

		end if;


		for I in 0 to bit_smp_tdl -1 loop

			
			if I*step_tap_tdl  < num_tap_tdl  then
				SampledTaps_TDL_tmp(I)	:=	AsyncTaps_TDL(I*step_tap_tdl);
			end if;

		end loop;

		return	SampledTaps_TDL_tmp;

	end function;
	------------------------------------------------


	
	procedure	X7S_Choose_AsyncTaps_TDL (

		
		type_tdl	:	string;												
		
		signal	CO_Taps	:	IN	STD_LOGIC_VECTOR;								
		signal	O_Taps	:	IN	STD_LOGIC_VECTOR;								
		
		signal	AsyncTaps_TDL	:	OUT	STD_LOGIC_VECTOR						

	) is

	begin

		
		if type_tdl = "C" then
			AsyncTaps_TDL	<=	CO_Taps;

		elsif type_tdl = "O" then
			AsyncTaps_TDL	<=	O_Taps;

		end if;


	end procedure;
	
end LocalPackage_TDC;