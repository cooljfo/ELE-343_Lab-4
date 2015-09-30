LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned. all;


entity MainDec is

Port (OP                          : in std_logic_vector(5 downto 0);
      MemtoReg, MemWrite, MemRead : out std_logic;
      Branch, AluSrc              : out std_logic;
      RegDst, RegWrite, Jump      : out std_logic;
      ALUOp                       : out std_logic_vector(1 downto 0) 
     );
end MainDec;


ARCHITECTURE MainDec_archi OF MainDec IS
--constant
constant R_TYPE : std_logic_vector(5 downto 0) :="000000";
constant LW     : std_logic_vector(5 downto 0) :="100011";
constant SW     : std_logic_vector(5 downto 0) :="101011";
constant BEQ    : std_logic_vector(5 downto 0) :="000100";
constant ADDI   : std_logic_vector(5 downto 0) :="001000";
constant J      : std_logic_vector(5 downto 0) :="000010";
--signal 
signal hex_code : std_logic_vector(11 downto 0);
BEGIN
     RegWrite <= hex_code(9);
     RegDst   <= hex_code(8);
     AluSrc   <= hex_code(7);
     Branch   <= hex_code(6);
     MemRead  <= hex_code(5);
     MemWrite <= hex_code(4);
     MemtoReg <= hex_code(3);
     ALUOp    <= hex_code(2 downto 1);
     Jump     <= hex_code(0);      
     process(OP)
     BEGIN
	 case OP is
		  when R_TYPE => hex_code <= X"304";
		  when LW     => hex_code <= X"2A8"; 
		  when SW     => hex_code <= X"090"; 
		  when BEQ    => hex_code <= X"042";
		  when ADDI   => hex_code <= X"280";
		  when J      => hex_code <= X"001";
		  when others => hex_code<=  "------------";
	   END case;
        end process;
	

END MainDec_archi;
