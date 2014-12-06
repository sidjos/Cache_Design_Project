library IEEE;
use IEEE.std_logic_1164.all; -- std_logic

entity or_gate_3to1_s is
  port (
    x_0, x_1, x_2 : in std_logic;
    z   : out std_logic
  );
end or_gate_3to1_s;

architecture or_gate_3to1_str of or_gate_3to1_s is
  signal or_so : std_logic;
begin 
  or_g1 : entity work.or_gate
    port map(x_0, x_1, or_so);

  or_g2 : entity work.or_gate
    port map(or_so, x_2, z);
end architecture or_gate_3to1_str;