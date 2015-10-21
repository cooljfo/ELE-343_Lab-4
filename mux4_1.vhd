library ieee;
use ieee.std_logic_1164.all;

entity mux4_1 is
  port(
    i0   : in  std_logic;
    i1   : in  std_logic;
    i2   : in  std_logic;
    i3   : in  std_logic;
    ctrl : in  std_logic_vector(1 downto 0);
    
    q    : out std_logic
  );
end mux4_1;

architecture rtl of mux4_1 is

 signal mux_2_1_1_out : std_logic;
 signal mux_2_1_2_out : std_logic;
 
begin
   
  mux2_1_ins1 : entity work.mux2_1
  port map(
    i0   =>i0,
    i1   =>i1,
    ctrl =>ctrl(0),
    q    =>mux_2_1_1_out
  );
  
  mux2_1_ins2 : entity work.mux2_1  
  port map(
    i0   =>i2,
    i1   =>i3,
    ctrl =>ctrl(0),
    q    =>mux_2_1_2_out
  );
  
  mux2_1_ins3 : entity work.mux2_1
  port map(
    i0=>mux_2_1_1_out,
    i1=>mux_2_1_2_out,
    ctrl=>ctrl(1),
    q=>q
  );
end;