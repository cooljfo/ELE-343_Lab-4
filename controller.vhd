library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage.all;

entity controller is 
  port (
    zero        : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    controlBus  : out controlBus_t
  );
end;

architecture rtl of controller is
  
alias opCode : std_logic_vector(5 downto 0) 
       is instruction (31 downto 26);
alias funct  : std_logic_vector(5 downto 0) 
       is instruction (5 downto 0);
--constant
constant R_TYPE : std_logic_vector(5 downto 0) :="000000";
constant LW     : std_logic_vector(5 downto 0) :="100011";
constant SW     : std_logic_vector(5 downto 0) :="101011";
constant BEQ    : std_logic_vector(5 downto 0) :="000100";
constant ADDI   : std_logic_vector(5 downto 0) :="001000";
constant J      : std_logic_vector(5 downto 0) :="000010";


--constant
constant ADD       : std_logic_vector (3 downto 0):="0010";
constant SUB       : std_logic_vector (3 downto 0):="0110";
constant ET        : std_logic_vector (3 downto 0):="0000";
constant OU        : std_logic_vector (3 downto 0):="0001";
constant SLT       : std_logic_vector (3 downto 0):="0111";
constant DONT_CARE : std_logic_vector (3 downto 0):="----";

constant ALUOP_ADD     : std_logic_vector (1 downto 0):="00";
constant ALUOP_SUB     : std_logic_vector (1 downto 0):="01";
constant ALUOP_FUNCT   : std_logic_vector (1 downto 0):="10";

constant FUNCT_ADD :  std_logic_vector(5 downto 0) := "100000";
constant FUNCT_SUB :  std_logic_vector(5 downto 0) := "100010";
constant FUNCT_ET  :  std_logic_vector(5 downto 0) := "100100";
constant FUNCT_OU  :  std_logic_vector(5 downto 0) := "100101";
constant FUNCT_SLT :  std_logic_vector(5 downto 0) := "101010";
--signal 
signal hex_code : std_logic_vector(11 downto 0);
signal ALUOp : std_logic_vector(1 downto 0);
signal Branch : std_logic;

BEGIN
     controlBus.RegWrite <= hex_code(9);
     controlBus.RegDst   <= hex_code(8);
     controlBus.AluSrc   <= hex_code(7);
                Branch   <= hex_code(6);
     controlBus.MemRead  <= hex_code(5);
     controlBus.MemWrite <= hex_code(4);
     controlBus.MemtoReg <= hex_code(3);
                ALUOp    <= hex_code(2 downto 1);
     controlBus.Jump     <= hex_code(0);   
   
     process(opCode)
     BEGIN
	 case opCode is
		  when R_TYPE => hex_code <= X"304";
		  when LW     => hex_code <= X"2A8"; 
		  when SW     => hex_code <= X"090"; 
		  when BEQ    => hex_code <= X"042";
		  when ADDI   => hex_code <= X"280";
		  when J      => hex_code <= X"001";
		  when others => hex_code<=  "------------";
	   END case;
        end process;
------main dec--------
------- alu dec-----------

     process(ALUOp,funct)
     BEGIN
	case(ALUOp) is
	 when ALUOP_ADD     => controlBus.ALUControl <= ADD;
	 when ALUOP_SUB     => controlBus.ALUControl <= SUB;
         when ALUOP_FUNCT   => 
			       case(funct) is
			        when FUNCT_ADD => controlBus.ALUControl <= ADD;
			        when FUNCT_SUB => controlBus.ALUControl <= SUB;
			        when FUNCT_ET  => controlBus.ALUControl <= ET;
                                when FUNCT_OU  => controlBus.ALUControl <= OU;
			        when FUNCT_SLT => controlBus.ALUControl <= SLT;
			        when others    => controlBus.ALUControl <= DONT_CARE;
			    end case;
         when others	    => controlBus.ALUControl <= DONT_CARE;
         end case;
        end process;
	
----------aludec------
controlBus.PCSrc <= Branch and Zero;
  
end;