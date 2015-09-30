LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned. all;


entity ALUDec is

Port (Funct      : in  std_logic_vector(5 downto 0);
      ALUOp      : in  std_logic_vector(1 downto 0);
      ALUControl : out std_logic_vector(3 downto 0) 
     );
end ALUDec;


ARCHITECTURE ALUDec_archi OF ALUDec IS
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

BEGIN
     process(ALUOp,Funct)
     BEGIN
	case(ALUOp) is
	 when ALUOP_ADD     => ALUControl <= ADD;
	 when ALUOP_SUB     => ALUControl <= SUB;
         when ALUOP_FUNCT   => 
			       case(Funct) is
			        when FUNCT_ADD => ALUControl <= ADD;
			        when FUNCT_SUB => ALUControl <= SUB;
			        when FUNCT_ET  => ALUControl <= ET;
                                when FUNCT_OU  => ALUControl <= OU;
			        when FUNCT_SLT => ALUControl <= SLT;
			        when others    => ALUControl <= DONT_CARE;
			    end case;
         when others	    => ALUControl <= DONT_CARE;
         end case;
        end process;
	

END ALUDec_archi;
