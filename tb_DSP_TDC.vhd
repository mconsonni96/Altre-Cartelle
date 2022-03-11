----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2022 11:27:07 AM
-- Design Name: 
-- Module Name: tb_AXI4Stream_DSP_TDC_Wrapper - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_DSP_TDC is
--  Port ( );
end tb_DSP_TDC;

architecture Behavioral of tb_DSP_TDC is
     
    constant	CLK_PERIOD 		: time := 1 ns;									
	constant	ASYNC_PERIOD 	: time := 12 ns;								
	
	constant	NUM_TAP_TDL		:	POSITIVE	RANGE 4 TO 4096	:= 48;
	
	component DSP_TDC is
    generic (
        
        NUM_TAP_TDL		:	POSITIVE	RANGE 4 TO 4096	:= 96										
		
		
	);


	port(

		
		clk	:	IN	STD_LOGIC;			 															
		
		
		AsyncInput	:	IN	STD_LOGIC;															
		
        O_Taps_TDL	:	OUT	STD_LOGIC_VECTOR(NUM_TAP_TDL-1 downto 0)
		
		
	);


    end component;


    
    signal clk   : std_logic := '1';
    
    signal	AsyncInput	:	STD_LOGIC;


	signal	O_Taps_TDL	:	STD_LOGIC_VECTOR(NUM_TAP_TDL-1 DOWNTO 0);
	
begin
    
    
    dut_DSP_TDC : DSP_TDC
     
       generic map ( 
                   
          NUM_TAP_TDL => NUM_TAP_TDL
          
       )
       port map ( 
       
          
          clk   => clk,
          AsyncInput => AsyncInput,
         O_Taps_TDL => O_Taps_TDL
          
       );
       
       
    clk_process :process
	begin
	   clk <= '0';
	   wait for CLK_PERIOD/2;
	   clk <= '1';
	   wait for CLK_PERIOD/2;
	end process;
	
	
	AsyncInput_process :process
	begin

		AsyncInput <= '0';
		wait for ASYNC_PERIOD/2;
		AsyncInput <= '1';
		wait ;

	end process;

end Behavioral;
