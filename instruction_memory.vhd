library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory is
  port (
    pc          : in  unsigned(31 downto 0);-- adresse d'accés à la mémoire envoyée par le MIPS de 6 bits
    
    instruction : out std_logic_vector(31 downto 0)
  ); 
end; 

architecture rtl of instruction_memory is

  constant rom_size : integer := 18;
  type romtype is array (rom_size-1 downto 0) of std_logic_vector(31 downto 0);
  constant rom : romtype := (
    0  =>x"20020005", --addi $2, $0, 5
    1  =>x"2003000C", --addi $3, $0, 12
    2  =>x"2067FFF7", --addi $7, $3, -9 
    3  =>x"00E22025", --or $4, $7, $2
    4  =>x"00642824", --and $5, $3, $4
    5  =>x"00A42820", --add $5, $5, $4
    6  =>x"10A7000A", --beq $5, $7, end
    7  =>x"0064202A",--slt $4, $3, $4
    8  =>x"10800001", --beq $4, $0, around
    9  =>x"20050000", --addi $5, $0, 10
    10 =>x"00E2202A", --slt $4, $7, $2
    11 =>x"00853820", --add $7, $4, $5
    12 =>x"00E23822", --sub $7, $7, $2
    13 =>x"AC670044", --sw $7, 68($3)
    14 =>x"8C020050", --lw $2, 80($0)
    15 =>x"08000011", --j end
    16 =>x"20020001", --addi $2, $0, 1
    17 =>x"AC020054" --sw $2, 84($0)
  );
  
begin

	instruction <= Rom(to_integer(pc(pc'high downto pc'low+2)));
  
end;

