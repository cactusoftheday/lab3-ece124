library ieee;
use ieee.std_logic_1164.all;

entity compx4 is
port (
	A : in std_logic_vector(3 downto 0);
	B : in std_logic_vector(3 downto 0);
	A_GREATER : out std_logic;
	B_GREATER : out std_logic;
	EQUAL : out std_logic
);

end compx4;

architecture compare of compx4 is

---COMPONENTS---
component compx1 port (
		INPUT_A : in std_logic;
		INPUT_B : in std_logic;
		A_GREATER : out std_logic;
		B_GREATER : out std_logic;
		EQUAL : out std_logic
	);
	end component;
	
	signal AGB : std_logic_vector(3 downto 0);
	signal AEB : std_logic_vector(3 downto 0);
	signal BGA : std_logic_vector(3 downto 0);


begin 

	INST1: compx1 port map(A(3), B(3), AGB(3), BGA(3), AEB(3));
	INST2: compx1 port map(A(2), B(2), AGB(2), BGA(2), AEB(2));
	INST3: compx1 port map(A(1), B(1), AGB(1), BGA(1), AEB(1));
	INST4: compx1 port map(A(0), B(0), AGB(0), BGA(0), AEB(0));
	
	
	EQUAL <= AEB(3) AND AEB (2) AND AEB(1) AND AEB (0);
	A_GREATER <= AGB(3) OR (AEB(3) AND (AGB(2) OR (AEB(2) AND (AGB(1) OR (AEB(1) AND AGB(0))))));
	B_GREATER <= BGA(3) OR (AEB(3) AND (BGA(2) OR (AEB(2) AND (BGA(1) OR (AEB(1) AND BGA(0))))));
	
	
				  
end compare;