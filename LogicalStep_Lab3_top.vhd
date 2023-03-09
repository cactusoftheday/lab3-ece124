library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
--	HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;

component compx4 port (
          A : in std_logic_vector(3 downto 0);
			 B : in std_logic_vector(3 downto 0);
			 A_GREATER : out std_logic;
			 B_GREATER : out std_logic;
			 EQUAL : out std_logic
        );
end component compx4;
	
component Tester port (
 MC_TESTMODE				: in  std_logic;
 I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
	); 
	end component;
	
component HVAC port (
	HVAC_SIM					: in boolean;
	clk						: in std_logic; 
	run		   			: in std_logic;
	increase, decrease	: in std_logic;
	temp						: out std_logic_vector (3 downto 0)
	);
end component;
------------------------------------------------------------------
-- Add any Other Components here
------------------------------------------------------------------
component Bidir_shift_reg port(
	CLK : in std_logic := '0';
	RESET : in std_logic := '0';
	CLK_EN : in std_logic := '0';
	LEFT_RIGHT: in std_logic := '0';
	REG_BITS : out std_logic_vector(7 downto 0)
);
end component;
component UDBinCounter8Bit port
	(
		clk : in std_logic;
		reset : in std_logic;
		clkEN : in std_logic;
		updown: in std_logic;
		counterbits : out std_logic_vector(7 downto 0)
	);
end component;
------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------	
constant HVAC_SIM : boolean := TRUE; -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                      -- or TRUE for doing simulations with the HVAC Component
------------------------------------------------------------------	

-- global clock
signal clk_in					: std_logic;
signal hex_A, hex_B 			: std_logic_vector(3 downto 0);
signal hexA_7seg, hexB_7seg: std_logic_vector(6 downto 0);
------------------------------------------------------------------- 
begin -- Here the circuit begins

clk_in <= clkin_50;	--hook up the clock input

-- temp inputs hook-up to internal busses.
hex_A <= sw(3 downto 0);
hex_B <= sw(7 downto 4);

variable current_temp : unsigned(3 downto 0); --assign this value to the comp and hex current temps below to transfer the data to the other modules
signal comp_current_temp : std_logic_vector(3 downto 0);
signal hex_current_temp : std_logic_vector(3 downto 0);

signal comp_output_temp: std_logic_vector(3 downto 0); --this goes into the argument slot of the comp, gotta split it up tho

inst1: sevensegment port map (hex_A, hexA_7seg);
inst2: sevensegment port map (hex_B, hexB_7seg);
inst3: segment7_mux port map (clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1);
--inst4: compx4 port map (hex_A, hex_B, leds(2), leds(0), leds(1));
--inst5: Bidir_shift_reg port map (clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
--inst5: UDBinCounter8Bit port map (clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
HVAC_instance: HVAC port map(HVAC_sim, clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(3 downto 0)); --testing the HVAC, remember that pb_n must be 0 for the HVAC to update
--button controls the run and switches control increase or decrease
		
end design;

