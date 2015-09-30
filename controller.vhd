LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned. all;


entity Controller is
port (OP, Funct                   : in std_logic_vector(5 downto 0);
      Zero                        : in std_logic;
      MemtoReg, MemWrite, MemRead : out std_logic;
      PCSrc, AluSrc               : out std_logic;
      RegDst, RegWrite            : out std_logic;
      Jump                        : out std_logic;
      AluControl                  : out std_logic_vector(3 downto 0)
     );
end; -- Controller;



ARCHITECTURE controller_archi OF Controller IS
--Component 
Component MainDec
Port (OP                          : in  std_logic_vector(5 downto 0);
      MemtoReg, MemWrite, MemRead : out std_logic;
      Branch, AluSrc              : out std_logic;
      RegDst, RegWrite, Jump      : out std_logic;
      ALUOp                       : out std_logic_vector(1 downto 0) );
END component;
Component ALUDec
Port (Funct      : in  std_logic_vector(5 downto 0);
      ALUOp      : in  std_logic_vector(1 downto 0);
      ALUControl : out std_logic_vector(3 downto 0) );
END component;
--constant

--signal 
signal signal_ALUOp : std_logic_vector(1 downto 0);
signal signal_Branch: std_logic;
BEGIN
             
U1 : MainDec
port map (OP,MemtoReg,MemWrite,MemRead,signal_Branch,AluSrc,RegDst,RegWrite,Jump,signal_ALUOp);
U2 : ALUDec
port map(Funct,signal_ALUOp,AluControl);

PCSrc <= signal_Branch and Zero;
      
	

END controller_archi;