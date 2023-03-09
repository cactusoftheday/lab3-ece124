library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity UDBinCounter8Bit is port
	(
		clk : in std_logic;
		reset : in std_logic;
		clkEN : in std_logic;
		updown: in std_logic;
		counterbits : out std_logic_vector(7 downto 0)
	);
end Entity;

ARCHITECTURE one of UDBinCounter8bit is
Signal udBinCounter: UNSIGNED(7 downto 0);

BEGIN

process(clk) is 
begin
	if(rising_edge(clk)) then
		if(reset = '1') then
			udBinCounter <= "00000000";
		elsif((clkEN = '1')) then
			if(updown = '1') then
				udBinCounter <= (udBinCounter + 1);
			else
				udBinCounter <= (udBinCounter - 1);
			end if;
		end if;
	end if;
	
	counterbits <= std_logic_vector(udBinCounter);
end process;

end;
