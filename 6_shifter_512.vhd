--DEBUG TIME !!!!

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity shifter_512 is
	port (
		x: 	in std_logic_vector(511 downto 0); -- 512-bit input data
		y: 	in std_logic_vector(5 downto 0);  -- Position to be shifted (activate with 1)
		z: 	out std_logic_vector(511 downto 0) -- Output
	);
end shifter_512;

architecture structural of shifter_512 is

signal mux0: std_logic_vector(511 downto 0);
signal mux1: std_logic_vector(511 downto 0);
signal mux2: std_logic_vector(511 downto 0);
signal mux3: std_logic_vector(511 downto 0);

begin
    
	mux0_map:	mux_n generic map (n=>512)	 port map (sel=>y(5), src0=>x, src1(511 downto 256)=>x(255 downto 0), src1(255 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux0);
	mux1_map:	mux_n generic map (n=>512)	 port map (sel=>y(4), src0=>mux0, src1(511 downto 128)=>mux0(383 downto 0),src1(127 downto 0)=>B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", z=>mux1);
	mux2_map:	mux_n generic map (n=>512)	 port map (sel=>y(3), src0=>mux1, src1(511 downto 64)=>mux1(447 downto 0),src1(63 downto 0)=>B"0000000000000000000000000000000000000000000000000000000000000000", z=>mux2);
   mux3_map:	mux_n generic map (n=>512)	 port map (sel=>y(2), src0=>mux2, src1(511 downto 32)=>mux2(479 downto 0),src1(31 downto 0)=>B"00000000000000000000000000000000", z=>z);
	
end architecture structural;

