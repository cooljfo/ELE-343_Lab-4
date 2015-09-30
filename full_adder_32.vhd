--================ full_adder_8.vhd =================================
-- ELE-340 Conception des systèmes ordinés
-- ETE 2007, Ecole de technologie supérieure
-- =============================================================
-- Description: additionneur ADDER_SIZE bits (par example ADDER_SIZE := 7)
-- =============================================================

LIBRARY ieee; USE ieee.std_logic_1164.all; USE ieee.std_logic_arith.all;
ENTITY full_adder_32 IS 
   GENERIC (ADDER_SIZE: integer := 31); -- Il suffit de chager la valeur 7 a 
						   -- celle de la taille de l'ALU desiree!
PORT (a_i, b_i: IN STD_LOGIC_VECTOR (ADDER_SIZE DOWNTO 0); 
     s_o : OUT STD_LOGIC_VECTOR (ADDER_SIZE DOWNTO 0);
     ret_o : OUT STD_LOGIC );
END full_adder_32;

ARCHITECTURE full_adder_32_archi OF full_adder_32 IS

COMPONENT full_adder PORT(
    a, b, c_in : IN STD_LOGIC;
    sum, c_out : OUT STD_LOGIC);
END COMPONENT;

SIGNAL sig_c : std_logic_vector(0 TO ADDER_SIZE+1);

BEGIN
sig_c(0)<='0';
full_adder_generic : FOR i IN 0 TO ADDER_SIZE GENERATE
full_adder_x : full_adder PORT MAP (a_i(i), b_i(i), sig_c(i), s_o(i), sig_c(i+1));
END GENERATE full_adder_generic;

ret_o <= sig_c(ADDER_SIZE+1);

END full_adder_32_archi;
