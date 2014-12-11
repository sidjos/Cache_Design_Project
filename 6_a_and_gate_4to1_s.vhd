library IEEE;
use IEEE.std_logic_1164.all; -- std_logic

entity and_gate_4to1_s is
  port (
    x_0, x_1, x_2, x_3 : in std_logic;
    z : out std_logic
  );
end and_gate_4to1_s;
  
architecture and_gate_4to1_str of and_gate_4to1_s is
  signal and_so0, and_so1 : std_logic;
begin 
  and_g0 : entity work.and_gate
    port map(x_0, x_1, and_so0);

  and_g1 : entity work.and_gate
    port map(x_2, x_3, and_so1);

  and_g2 : entity work.and_gate
    port map(and_so0, and_so1, z);
end architecture and_gate_4to1_str;
