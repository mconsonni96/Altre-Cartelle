
--  ############ Insert Only the Usefor Sections ################

---------- DEFAULT LIBRARY ---------
library IEEE;
	use IEEE.STD_LOGIC_1164.all;
	use IEEE.NUMERIC_STD.ALL;
--	use IEEE.MATH_REAL.all;

--	use STD.textio.all;
--	use ieee.std_logic_textio.all;

------------------------------------


---------- OTHERS LIBRARY ----------
-- NONE
------------------------------------




entity tb_GenericVHDL is
end tb_GenericVHDL;

architecture Behavioral of tb_GenericVHDL is

	------------------ CONSTANT DECLARATION -------------------------

	--------- Timing -----------
	constant	CLK_PERIOD 	:	TIME	:= 10 ns;
	constant	RESET_WND	:	TIME	:= 10*CLK_PERIOD;
	----------------------------

	--- TB Initialiazzations ---
	constant	TB_CLK_INIT		:	STD_LOGIC	:= '0';
	constant	TB_RESET_INIT 	:	STD_LOGIC	:= '1';
	----------------------------


	------- DUT Generics -------
	-- NONE
	----------------------------

	---------- OTHERS ----------
	-- NONE
	----------------------------

	-----------------------------------------------------------------



	------------------------ TYPES DECLARATION ----------------------

	--------- SECTION ----------
	-- NONE
	----------------------------

	-----------------------------------------------------------------



	
	--------------------- FUNCTIONS DECLARATION ---------------------

	--------- SECTION ----------
	-- NONE
	----------------------------	
	
	-----------------------------------------------------------------		



	------ COMPONENT DECLARATION for the Device Under Test (DUT) ------

	-------- First DUT ---------
	-- NONE
	----------------------------


	--------- Last DUT ---------
	-- NONE
	----------------------------

	------------------------------------------------------------------




	--------------------- SIGNALS DECLARATION -----------------------


	------- Clock/Reset  -------
	signal	reset	:	STD_LOGIC	:= TB_RESET_INIT;
	signal	clk		:	STD_LOGIC	:= TB_CLK_INIT;
	----------------------------

	----- First DUT Signals ----
	-- NONE
	----------------------------


	----- Last DUT Signals -----
	-- NONE
	----------------------------


	----- OTHERS Signals -------
	-- NONE
	----------------------------

	----------------------------------------------------------------




	-------------------------- ATTRIBUTES --------------------------

	--------- SECTION ----------
	-- NONE
	----------------------------	
	
	-----------------------------------------------------------------




begin




	--------------------- COMPONENTS DUT WRAPPING --------------------

	-------- First DUT ---------
	-- NONE
	----------------------------


	--------- Last DUT ---------
	-- NONE
	----------------------------


	-------------------------------------------------------------------


	--------------------- TEST BENCH DATA FLOW  -----------------------

	---------- clock ----------
	clk<= not clk after  CLK_PERIOD/2;
	----------------------------

	--------- SECTION ----------
	-- NONE
	----------------------------

	-------------------------------------------------------------------


	---------------------- TEST BENCH PROCESS -------------------------


	----- Reset Process --------
	reset_wave :process
	begin
		reset <= RESET_INIT;
		wait for RESETWND;

		reset <= not reset;
		wait;
    end process;
	----------------------------


   ------ Stimulus process -------

    stim_proc: process
    begin
		-- waiting the reset wave
		wait for RESET_WND;


		-- Start


        -- Stop
		wait;


		

      wait;
    end process;
	----------------------------


	------ Sync Process --------
	-- NONE
	----------------------------


	----- Async Process --------
	-- NONE
	----------------------------


	--------- SECTION ----------
	-- NONE
	----------------------------

	-------------------------------------------------------------------


end;
