-- Le Sync Man: if input, stay high for only one clock cycle

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity syncboss is 
port(
    clk     : in std_logic;
    b: in std_logic;
    Enable: in std_logic;
    sync: out std_logic
    );
end syncboss;

architecture structural of syncboss is
    
    component and_gate_3to1_s is
      port (
        x_0, x_1, x_2    : in std_logic;
        z    : out std_logic
      );
    end component;
    
    signal q0, q0b, q1, q1b, d0, d1, s0, s1 : std_logic;
    
    begin
        
        m0: and_gate_3to1_s port map (q0b, q1, b, s0);
        m1: and_gate_3to1_s  port map (q0, q1b, b, s1);
        m2: or_gate port map ( s0, s1, d0);
        m3: dffr_a port map ( clk, Enable, '0','0', d0, '1',q0);
        m4: and_gate_3to1_s port map (q0b, q1b, b, d1);
        m6: dffr_a port map ( clk, Enable, '0','0',d1,'1', q1);
        m7: and_gate port map (q0b, q1, sync);
        m8: not_gate port map (q0, q0b);
        m9: not_gate port map (q1, q1b);
        
end structural;
        