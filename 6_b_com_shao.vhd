library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity tag_L2_compare is
	port (
		input_0: 	in std_logic_vector(2069 downto 0); -- 22-bit tag + 256 bytes
		input_1: 	in std_logic_vector(2069 downto 0); 
		input_2: 	in std_logic_vector(2069 downto 0); 
		input_3:	in std_logic_vector(2069 downto 0);
		tag:		in std_logic_vector(21 downto 0);
		output:		out std_logic_vector(2069 downto 0);
		hit:		out std_logic
	);
end tag_L2_compare;

architecture structural of tag_L2_compare is

signal mux0: std_logic_vector(2069 downto 0);
signal mux1: std_logic_vector(2069 downto 0);
signal mux2: std_logic_vector(511 downto 0);


signal com0: std_logic;
signal com1: std_logic;
signal com2: std_logic;
signal com3: std_logic;

signal or0: std_logic;
signal or1: std_logic;
signal or2: std_logic;

begin
    	--compare tag
    	com0_map:	cmp_n generic map (n=>22)	 port map (a=>input_0(2069 downto 2048), b=>tag, a_eq_b=>com0);
    	com1_map:	cmp_n generic map (n=>22)	 port map (a=>input_1(2069 downto 2048), b=>tag, a_eq_b=>com1);
    	com2_map:	cmp_n generic map (n=>22)	 port map (a=>input_2(2069 downto 2048), b=>tag, a_eq_b=>com2);
    	com3_map:	cmp_n generic map (n=>22)	 port map (a=>input_3(2069 downto 2048), b=>tag, a_eq_b=>com3);
    	
    	--hit
    	or0_map:	or_gate 			 port map (x=>com0,y=>com1,z=>or0);
    	or1_map:	or_gate 			 port map (x=>com2,y=>com3,z=>or1);
    	or2_map:	or_gate 			 port map (x=>com2,y=>com3,z=>hit);
    	
    	--output 
	mux0_map:	mux_n generic map (n=>2070)	 port map (sel=>com1, src0=>input_0, src1=>input_1, z=>mux0);
	mux1_map:	mux_n generic map (n=>2070)	 port map (sel=>com2, src0=>input_2, src1=>input_3, z=>mux1);
	and0_map:	or_gate			 	 port map (x=>com2, y=>com3, z=>or2);
	mux2_map:	mux_n generic map (n=>2070)	 port map (sel=>or2, src0=>mux0, src1=>mux1, z=>output);
	
end architecture structural;

