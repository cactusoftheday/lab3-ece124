library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EnergyMonitor is

	port
	(
		--inputs below
		--comes from push buttons
		vacation_mode : in std_logic;
		MC_test_mode : in std_logic;
		window_open : in std_logic;
		door_open : in std_logic;
		
		--comes from comparator
		GreaterThanB : in std_logic;
		LessThanB : in std_logic;
		EqualToB : in std_logic;
		
		--LED outputs below
		furnace: out std_logic; --leds[0]
		at_temp: out std_logic; --leds[1]
		AC : out std_logic; -- leds[2]
		blower : out std_logic; --leds[3]
		window : out std_logic; --leds[4]
		door : out std_logic; --leds[5]
		MC_test_pass : out std_logic --leds[6] This is the tester output
		vacation: out std_logic; --leds[7]
		
		--Energy Monitor outputs that lead to HVAC below
		decrease: out std_logic;
		increase: out std_logic;
		run : out std_logic;
	);
end entity;

architecture eng of EnergyMonitor is 
--mux_temp is coming from the switches same goes for desired_temp
--current_temp is coming from the HVAC
--assuming that mux_temp is equivalent to input1 (A) and current_temp is equivalent to input2 (B)

--declare signals here

begin
	if(EqualToB = '1') or (window_open = '1') or (door_open = '1') or (MC_test_mode = '1')then --fulfills 3,4,5
		run <= '0';
	end if;
	if(GreaterThanB = '1') then --condition 6
		--AC LED ON
		AC <= '1';
		decrease <= '1';
		increase <= '0';
	end if;
	if(LessThanB = '1') then --condition 7
		furnace <= '1';
		increase <= '1';
		decrease <= '0';
	end if;
	if(EqualToB = '1') then --condition 8
		at_temp <= 1;
		blower <= 0;
	end if;
	if(EqualToB = '0') and NOT(MC_test_mode = '1' or window_open = '1' or door_open = '1') then --condition 9
		blower <= '1';
	end if;
	if(door_open = '1') then --condition 10
		door <= '1';
	end if;
	if(window_open = '1') then --condition 11
		window = '1';
	end if;
	if(vacation_mode = '1') then --condition 12
		vacation <= '1';
	end if;
	
	--Daniel, you need to figure out how to change the decrease and increase signals, I've just kind of haphazardly slapped them in

end process;

end eng;