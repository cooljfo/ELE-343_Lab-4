library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage.all;

entity logic_pc is 
  port (
    clk         : in  std_logic;
    reset       : in  std_logic;
    instruction : in  std_logic_vector(31 downto 0);
    controlBus  : in  controlBus_t;     
    pc          : out unsigned(31 downto 0)
  ); 
end;

architecture rtl of logic_pc is
signal signImm,signImmSh,pcBranch,pcJump,pcPlus4,s_pc  : unsigned (31 downto 0):= (others =>'0');
signal s_instruction25_0                               : unsigned (25 downto 0):= (others =>'0');
signal s_instruction27_0		               : unsigned (27 downto 0):= (others =>'0');
signal s_instruction15_0                               : unsigned (15 downto 0):= (others =>'0');
 	 

begin 

pcPlus4           <= s_pc+4;
s_instruction25_0 <= unsigned(instruction(25 downto 0));
s_instruction15_0 <= unsigned(instruction(15 downto 0));
signImm           <= unsigned(resize(signed(s_instruction15_0), signImm'length));
signImmSh         <= signImm sll 2;
pcBranch          <= signImmSh + pcPlus4 ;

s_instruction27_0 <= unsigned(resize(unsigned(s_instruction25_0), s_instruction27_0'length));
pcJump 		  <= pcPlus4(31 downto 28) &(s_instruction27_0 sll 2); 
 process (clk)
  begin
    if (rising_edge(clk) and reset = '1') then
        if   (controlBus.pcSrc = '0' AND controlBus.jump ='0') then
          pc   <= pcPlus4;
	  s_pc <= pcPlus4;
	elsif(controlBus.pcSrc = '1' AND controlBus.jump ='0') then  
 	  pc   <= pcBranch;
	  s_pc <= pcBranch;
        else
          pc   <= pcJump;
	  s_pc <= pcJump;
        end if;
    end if;
    if (rising_edge(clk) and reset = '0') then
        pc <= (others => '0' );
    end if;
  end process;
end;