library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HVAC is
	port
	(
		HVAC_SIM : in boolean;
		clk : in std_logic;
		run : in std_logic;
		increase, decrease : in std_logic;
		temp : out std_logic_vector (3 downto 0)
	);
end entity;

architecture rtl of HVAC is

signal clk_2hz : std_logic;
signal HVAC_clk : std_logic;
signal digital_counter : std_logic_vector(23 downto 0);

begin

--clk_divider process to generate our 1 degree increment every 330 milliseconds

clk_divider: process (clk)
	variable counter : unsigned(23 downto 0);
	
	begin
--Synchronously update counter
		if(rising_edge(clk)) then
			counter := counter + 1;
		end if;
		digital_counter <= std_logic_vector(counter);
	end process;
	
clk_2hz <= digital_counter(23);

--when HVAC_SIM is true then we are in testing mode meaning the clk frequency is pretty quick to make the simulation time short
clk_mux: process(HVAC_SIM)
	begin
		if(HVAC_SIM) then
			HVAC_clk <= clk;
		else
			HVAC_clk <= clk_2hz;
		end if;
	end process;

counter: process (HVAC_clk)
	variable count : unsigned(3 downto 0) := "0111"; --the middle of the 4 bit integers (7)
	begin
	--Synchronously update counter
		if((run = '1') and rising_edge(HVAC_clk)) then --only update counter when run is 1 or on and when the HVAC clock is on too
			if((increase = '1') and (count < "1111")) then --don't increase past 15
				count := (count + 1);
			elsif((decrease = '1') and (count > "0000")) then --don't decrease past 0
				count := (count - 1);
			end if;
		end if;	
	
	--Output the current count
		temp <= std_logic_vector(count);
	end process;
	
end rtl;	
	