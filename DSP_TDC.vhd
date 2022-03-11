-------------------------------------------------------------------------------------------------------------------------
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

----------------------------- LIBRARY DECLARATION ------------------------------

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


---------- XILINX LIBRARY ----------
--! Xilinx Unisim library
library UNISIM;
--! Xilinx Unisim VComponent library
 	use UNISIM.VComponents.all;

-- --! \brief Xilinx Parametric Macro library
-- --! \details To be correctly used in Vivado write auto_detect_xpm into tcl console.
-- library xpm;
-- 	--! Xilinx Parametric Macro VComponent library
-- 	use xpm.vcomponents.all;
-- ------------------------------------


-- ------------ LOCAL LIBRARY ---------
-- --! Project defined libary
library work;
--! Tapped Delay-Line local package
	use work.LocalPackage_TDC.all;
------------------------------------

--------------------------------------------------------------------------------


entity DSP_TDC is
	generic (

        NUM_TAP_TDL				:	POSITIVE	RANGE 4 TO 4096	:= 96					
		
	);
	port(
		
		clk : in std_logic;
		
		AsyncInput	:	IN	STD_LOGIC;											
		
        O_Taps_TDL	:	OUT	STD_LOGIC_VECTOR(NUM_TAP_TDL-1 downto 0)				
		
	);
end DSP_TDC;


architecture Behavioral of DSP_TDC is

	 constant	BIT_DSP	:	POSITIVE	:= 48;
	
	 constant	NUM_DSP	:	INTEGER	:=								
		Compute_Num_DSP
		(
			NUM_TAP_TDL,
			BIT_DSP
		);
		
	type array_type is array(0 to NUM_DSP-1) of std_logic;
    signal CARRYCASCOUT : array_type;

	signal O	: std_logic_vector(NUM_DSP*BIT_DSP-1 downto 0);		
	
	
    signal CARRYIN : std_logic := '0';

	----------------------------------------------------------------------------


begin
    CARRYIN <=  AsyncInput;
    O_Taps_TDL	<=	O(NUM_TAP_TDL - 1 downto 0);

    DSP48E1_inst : DSP48E1
    generic map (
      -- Feature Control Attributes: Data Path Selection
      A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
      B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
      USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
      USE_MULT => "NONE",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
      USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
      -- Pattern Detector Attributes: Pattern Detection Configuration
      AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
      MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
      PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
      SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
      SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
      USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
      -- Register Control Attributes: Pipeline Register Configuration
      ACASCREG => 0,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
      ADREG => 0,                        -- Number of pipeline stages for pre-adder (0 or 1)
      ALUMODEREG => 0,                   -- Number of pipeline stages for ALUMODE (0 or 1)
      AREG => 0,                         -- Number of pipeline stages for A (0, 1 or 2)
      BCASCREG => 0,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
      BREG => 0,                         -- Number of pipeline stages for B (0, 1 or 2)
      CARRYINREG => 1,                   -- Number of pipeline stages for CARRYIN (0 or 1)
      CARRYINSELREG => 0,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
      CREG => 0,                         -- Number of pipeline stages for C (0 or 1)
      DREG => 0,                         -- Number of pipeline stages for D (0 or 1)
      INMODEREG => 0,                    -- Number of pipeline stages for INMODE (0 or 1)
      MREG => 0,                         -- Number of multiplier pipeline stages (0 or 1)
      OPMODEREG => 0,                    -- Number of pipeline stages for OPMODE (0 or 1)
      PREG => 0                          -- Number of pipeline stages for P (0 or 1)
   )
   port map (
      -- Cascade: 30-bit (each) output: Cascade Ports
      ACOUT => open,                   -- 30-bit output: A port cascade output
      BCOUT => open,                   -- 18-bit output: B port cascade output
      CARRYCASCOUT => CARRYCASCOUT(0),     -- 1-bit output: Cascade carry output
      MULTSIGNOUT => open,       -- 1-bit output: Multiplier sign cascade output
      PCOUT => open,                   -- 48-bit output: Cascade output
      -- Control: 1-bit (each) output: Control Inputs/Status Bits
      OVERFLOW => open,             -- 1-bit output: Overflow in add/acc output
      PATTERNBDETECT => open, -- 1-bit output: Pattern bar detect output
      PATTERNDETECT => open,   -- 1-bit output: Pattern detect output
      UNDERFLOW => open,           -- 1-bit output: Underflow in add/acc output
      -- Data: 4-bit (each) output: Data Ports
      CARRYOUT => open,             -- 4-bit output: Carry output
      P => O(BIT_DSP-1 downto 0),                           -- 48-bit output: Primary data output
      -- Cascade: 30-bit (each) input: Cascade Ports
      ACIN => (Others => '0'),                     -- 30-bit input: A cascade data input
      BCIN => (Others => '0'),                     -- 18-bit input: B cascade input
      CARRYCASCIN => '0',       -- 1-bit input: Cascade carry input
      MULTSIGNIN => '0',         -- 1-bit input: Multiplier sign input
      PCIN => (Others => '0'),                     -- 48-bit input: P cascade input
      -- Control: 4-bit (each) input: Control Inputs/Status Bits
      ALUMODE => (Others => '0'),               -- 4-bit input: ALU control input
      CARRYINSEL => "000",         -- 3-bit input: Carry select input
      CLK => clk,                       -- 1-bit input: Clock input
      INMODE => (Others => '0'),                 -- 5-bit input: INMODE control input
      OPMODE => "0110011", --Others => '0'),                 -- 7-bit input: Operation mode input
      -- Data: 30-bit (each) input: Data Ports
      A => (Others => '0'),                           -- 30-bit input: A data input
      B => (Others => '0'),                           -- 18-bit input: B data input
      C => (Others => '1'),                           -- 48-bit input: C data input
      CARRYIN => CARRYIN,               -- 1-bit input: Carry input signal
      D => (Others => '0'),                           -- 25-bit input: D data input
      -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
      CEA1 => '1',                     -- 1-bit input: Clock enable input for 1st stage AREG
      CEA2 => '1',                     -- 1-bit input: Clock enable input for 2nd stage AREG
      CEAD => '1',                     -- 1-bit input: Clock enable input for ADREG
      CEALUMODE => '1',           -- 1-bit input: Clock enable input for ALUMODE
      CEB1 => '1',                     -- 1-bit input: Clock enable input for 1st stage BREG
      CEB2 => '1',                     -- 1-bit input: Clock enable input for 2nd stage BREG
      CEC => '1',                       -- 1-bit input: Clock enable input for CREG
      CECARRYIN => '1',           -- 1-bit input: Clock enable input for CARRYINREG
      CECTRL => '1',                 -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
      CED => '1',                       -- 1-bit input: Clock enable input for DREG
      CEINMODE => '1',             -- 1-bit input: Clock enable input for INMODEREG
      CEM => '1',                       -- 1-bit input: Clock enable input for MREG
      CEP => '1',                       -- 1-bit input: Clock enable input for PREG
      RSTA => '0',                     -- 1-bit input: Reset input for AREG
      RSTALLCARRYIN => '0',   -- 1-bit input: Reset input for CARRYINREG
      RSTALUMODE => '0',         -- 1-bit input: Reset input for ALUMODEREG
      RSTB => '0',                     -- 1-bit input: Reset input for BREG
      RSTC => '0',                     -- 1-bit input: Reset input for CREG
      RSTCTRL => '0',               -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
      RSTD => '0',                     -- 1-bit input: Reset input for DREG and ADREG
      RSTINMODE => '0',           -- 1-bit input: Reset input for INMODEREG
      RSTM => '0',                     -- 1-bit input: Reset input for MREG
      RSTP => '0'                      -- 1-bit input: Reset input for PREG
   );







		
		Gen_DSP48E1_TDC : for I in 1 to NUM_DSP-1 generate
		begin

		
		
            DSP48E1_inst : DSP48E1
                generic map ( 
                    -- Feature Control Attributes: Data Path Selection
                    A_INPUT => "DIRECT",               -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
                    B_INPUT => "DIRECT",               -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
                    USE_DPORT => FALSE,                -- Select D port usage (TRUE or FALSE)
                    USE_MULT => "NONE",            -- Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
                    USE_SIMD => "ONE48",               -- SIMD selection ("ONE48", "TWO24", "FOUR12")
                    -- Pattern Detector Attributes: Pattern Detection Configuration
                    AUTORESET_PATDET => "NO_RESET",    -- "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
                    MASK => X"3fffffffffff",           -- 48-bit mask value for pattern detect (1=ignore)
                    PATTERN => X"000000000000",        -- 48-bit pattern match for pattern detect
                    SEL_MASK => "MASK",                -- "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2" 
                    SEL_PATTERN => "PATTERN",          -- Select pattern value ("PATTERN" or "C")
                    USE_PATTERN_DETECT => "NO_PATDET", -- Enable pattern detect ("PATDET" or "NO_PATDET")
                    -- Register Control Attributes: Pipeline Register Configuration
                    ACASCREG => 0,                     -- Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
                    ADREG => 0,                        -- Number of pipeline stages for pre-adder (0 or 1)
                    ALUMODEREG => 0,                   -- Number of pipeline stages for ALUMODE (0 or 1)
                    AREG => 0,                         -- Number of pipeline stages for A (0, 1 or 2)
                    BCASCREG => 0,                     -- Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
                    BREG => 0,                         -- Number of pipeline stages for B (0, 1 or 2)
                    CARRYINREG => 1,                   -- Number of pipeline stages for CARRYIN (0 or 1)
                    CARRYINSELREG => 0,                -- Number of pipeline stages for CARRYINSEL (0 or 1)
                    CREG => 0,                         -- Number of pipeline stages for C (0 or 1)
                    DREG => 0,                         -- Number of pipeline stages for D (0 or 1)
                    INMODEREG => 0,                    -- Number of pipeline stages for INMODE (0 or 1)
                    MREG => 0,                         -- Number of multiplier pipeline stages (0 or 1)
                    OPMODEREG => 0,                    -- Number of pipeline stages for OPMODE (0 or 1)
                    PREG => 0        
                )
                port map ( 
                    -- Cascade: 30-bit (each) output: Cascade Ports
                    ACOUT => open,                   -- 30-bit output: A port cascade output
                    BCOUT => open,                   -- 18-bit output: B port cascade output
                    CARRYCASCOUT => CARRYCASCOUT(I),     -- 1-bit output: Cascade carry output
                    MULTSIGNOUT => open,       -- 1-bit output: Multiplier sign cascade output
                    PCOUT => open,                   -- 48-bit output: Cascade output
                    -- Control: 1-bit (each) output: Control Inputs/Status Bits
                    OVERFLOW => open,             -- 1-bit output: Overflow in add/acc output
                    PATTERNBDETECT => open, -- 1-bit output: Pattern bar detect output
                    PATTERNDETECT => open,   -- 1-bit output: Pattern detect output
                    UNDERFLOW => open,           -- 1-bit output: Underflow in add/acc output
                    -- Data: 4-bit (each) output: Data Ports
                    CARRYOUT => open,             -- 4-bit output: Carry output
                    P => O(BIT_DSP*(I+1)-1 downto BIT_DSP*I),                           -- 48-bit output: Primary data output
                    -- Cascade: 30-bit (each) input: Cascade Ports
                    ACIN => (Others => '0'),                     -- 30-bit input: A cascade data input
                    BCIN => (Others => '0'),                     -- 18-bit input: B cascade input
                    CARRYCASCIN => CARRYCASCOUT(I-1),       -- 1-bit input: Cascade carry input
                    MULTSIGNIN => '0',         -- 1-bit input: Multiplier sign input
                    PCIN => (Others => '0'),                     -- 48-bit input: P cascade input
                    -- Control: 4-bit (each) input: Control Inputs/Status Bits
                    ALUMODE => (Others => '0'),               -- 4-bit input: ALU control input
                    CARRYINSEL => "010",         -- 3-bit input: Carry select input
                    CLK => clk,                       -- 1-bit input: Clock input
                    INMODE => (Others => '0'),                 -- 5-bit input: INMODE control input
                    OPMODE => ("0110011"), --Others => '0'),                 -- 7-bit input: Operation mode input
                    -- Data: 30-bit (each) input: Data Ports
                    A => (Others => '0'),                           -- 30-bit input: A data input
                    B => (Others => '0'),                           -- 18-bit input: B data input
                    C => (Others => '1'),                           -- 48-bit input: C data input
                    CARRYIN => '0',               -- 1-bit input: Carry input signal
                    D => (Others => '0'),                           -- 25-bit input: D data input
                    -- Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
                    CEA1 => '1',                     -- 1-bit input: Clock enable input for 1st stage AREG
                    CEA2 => '1',                     -- 1-bit input: Clock enable input for 2nd stage AREG
                    CEAD => '1',                     -- 1-bit input: Clock enable input for ADREG
                    CEALUMODE => '1',           -- 1-bit input: Clock enable input for ALUMODE
                    CEB1 => '1',                     -- 1-bit input: Clock enable input for 1st stage BREG
                    CEB2 => '1',                     -- 1-bit input: Clock enable input for 2nd stage BREG
                    CEC => '1',                       -- 1-bit input: Clock enable input for CREG
                    CECARRYIN => '1',           -- 1-bit input: Clock enable input for CARRYINREG
                    CECTRL => '1',                 -- 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
                    CED => '1',                       -- 1-bit input: Clock enable input for DREG
                    CEINMODE => '1',             -- 1-bit input: Clock enable input for INMODEREG
                    CEM => '1',                       -- 1-bit input: Clock enable input for MREG
                    CEP => '1',                       -- 1-bit input: Clock enable input for PREG
                    RSTA => '0',                     -- 1-bit input: Reset input for AREG
                    RSTALLCARRYIN => '0',   -- 1-bit input: Reset input for CARRYINREG
                    RSTALUMODE => '0',         -- 1-bit input: Reset input for ALUMODEREG
                    RSTB => '0',                     -- 1-bit input: Reset input for BREG
                    RSTC => '0',                     -- 1-bit input: Reset input for CREG
                    RSTCTRL => '0',               -- 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
                    RSTD => '0',                     -- 1-bit input: Reset input for DREG and ADREG
                    RSTINMODE => '0',           -- 1-bit input: Reset input for INMODEREG
                    RSTM => '0',                     -- 1-bit input: Reset input for MREG
                    RSTP => '0'                       -- 1-bit input: Reset input for PREG
                );
                
                
			
		end generate;

	

end Behavioral;