LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned. all;


entity mux32 is

generic(
	N: integer := 31
);
port (InputOne                   : in std_logic_vector(N downto 0);
      InputTwo                   : in std_logic_vector(N downto 0);
      Selecter                   : in std_logic;
      Output                     : out std_logic_vector(N downto 0)
     );
end mux32; -- Controller;

architecture Mux32_Archi of Mux32 is

begin

Output <= InputOne when Selecter = '0' else 
	  InputTwo when Selecter = '1';


end Mux32_Archi;
