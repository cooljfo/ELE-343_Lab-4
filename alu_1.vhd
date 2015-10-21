library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_1 is 
  port (
    a            : in  std_logic;
    b            : in  std_logic;
    c_in         : in  std_logic;
    less         : in  std_logic;
    alucontrol   : in  std_logic_vector;

    c_out        : out std_logic;
    result       : out std_logic;
    set          : out std_logic
  ); 
end;

architecture rtl of alu_1 is

--declarer les signaux ici 
  
  alias  Operation      : std_logic_vector(1 downto 0) is alucontrol(1 downto 0);
  alias  B_inv          : std_logic is alucontrol(2);
  alias  A_inv          : std_logic is alucontrol(3);
  
  signal not_a          : std_logic;
  signal not_B          : std_logic;
  signal a_in           : std_logic;
  signal b_in           : std_logic;
  signal full_adder_out : std_logic;
  signal and_out        : std_logic;
  signal or_out         : std_logic;


begin
  not_a <= not(a);
  not_b <= not(b);

  
  and_out <= a_in and b_in;
  or_out  <= a_in or b_in;
  
  mux2_1_inst1 : entity work.mux2_1
  port map(
    i0   =>a,
    i1   =>not_a,
    ctrl =>A_inv,
    q    =>a_in
  );

  mux2_1_inst2 : entity work.mux2_1
  port map(
    i0   =>b,
    i1   =>not_b,
    ctrl =>B_inv,
    q    =>b_in
  );


  full_adder_inst : entity work.full_adder
  port map(
    a     =>a_in,
    b     =>b_in,
    c_i   =>c_in,
    sum   =>full_adder_out,
    c_out =>c_out
  );

  mux4_1_inst1 : entity work.mux4_1
  port map(
    i0   =>and_out,
    i1   =>or_out,
    i2   =>full_adder_out,
    i3   =>less,
    ctrl =>Operation,
    q    =>result
  );

  set <= full_adder_out;

end;