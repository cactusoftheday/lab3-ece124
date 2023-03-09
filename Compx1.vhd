library ieee;
use ieee.std_logic_1164.all;

entity Compx1 is
port (
	INPUT_A : in std_logic;
	INPUT_B : in std_logic;
	A_GREATER : out std_logic;
	B_GREATER : out std_logic;
	EQUAL : out std_logic
	
);

end Compx1;

architecture compare of Compx1 is

begin 

	--for the ADDING OF 3 BITS
	EQUAL <= (INPUT_A XNOR INPUT_B);
	A_GREATER <= INPUT_A AND (NOT INPUT_B);
	B_GREATER <= INPUT_B AND (NOT INPUT_A);
	
				  
end compare;