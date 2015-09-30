library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Ceci est un commentaire

entity DFF is
generic(
	 INPUT_LENGTH: integer := 31
        );
  Port ( D          : in  STD_LOGIC_VECTOR(INPUT_LENGTH DOWNTO 0);
         clk        : in  STD_LOGIC;
         reset      : in  STD_LOGIC; 
         Q          : out STD_LOGIC_VECTOR(INPUT_LENGTH DOWNTO 0)
       );
end DFF;

--Description de l'app
architecture DFF of DFF is
  
  begin 
        process(clk,reset)
          begin
            IF clk 'event AND clk ='1' then
              Q <= D;
            end if;
            IF reset = '0' AND clk'event AND clk = '1' then
              Q <= (others => '0');
            end if ;
          end process;
         
end DFF;
