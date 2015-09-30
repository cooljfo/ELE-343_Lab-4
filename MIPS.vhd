LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned. all;

ENTITY  MIPS is 
GENERIC (MIPS_SIZE: integer := 31); 
PORT (clk,reset   : in std_logic;
      instruction : in std_logic_vector(MIPS_SIZE downto 0);
      ReadData    : in std_logic_vector(MIPS_SIZE downto 0);
      PC          : in std_logic_vector(MIPS_SIZE downto 0); 
      ALUResult   : in std_logic_vector(MIPS_SIZE downto 0);
      WriteData   : in std_logic_vector(MIPS_SIZE downto 0)  
     );
end MIPS;
ARCHITECTURE MIPS_archi OF MIPS IS

COMPONENT MainDec 
PORT (OP                          : in std_logic_vector(5 downto 0);
      MemtoReg, MemWrite, MemRead : out std_logic;
      Branch, AluSrc              : out std_logic;
      RegDst, RegWrite, Jump      : out std_logic;
      ALUOp                       : out std_logic_vector(1 downto 0) 
     );END COMPONENT;
BEGIN
END MIPS_archi;