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
		hit:		out std_logic;
		comp:	out std_logic_vector(3 downto 0)
		
	);
end tag_L2_compare;

architecture structural of tag_L2_compare is

signal mux0,mux1,mux2: std_logic_vector(2069 downto 0);
signal com0,com1,com2,com3,or0,or1,or2: std_logic;
signal selectSid: std_logic_vector (1 downto 0);

begin
    	--compare tag
    	com0_map:	cmp_n generic map (n=>22)	 port map (a=>input_0(2069 downto 2048), b=>tag, a_eq_b=>com0);
    	com1_map:	cmp_n generic map (n=>22)	 port map (a=>input_1(2069 downto 2048), b=>tag, a_eq_b=>com1);
    	com2_map:	cmp_n generic map (n=>22)	 port map (a=>input_2(2069 downto 2048), b=>tag, a_eq_b=>com2);
    	com3_map:	cmp_n generic map (n=>22)	 port map (a=>input_3(2069 downto 2048), b=>tag, a_eq_b=>com3); 

	comp(0)<=com0;
	comp(1)<=com1;
	comp(2)<=com2;
	comp(3)<=com3;
    	
sid0: or_gate port map (com1, com3, selectSid(0));
sid1: or_gate port map (com2, com3, selectSid(1));


    	--hit
    	or0_map:	or_gate 			 port map (x=>com0,y=>com1,z=>or0);
    	or1_map:	or_gate 			 port map (x=>com2,y=>com3,z=>or1);
    	or2_map:	or_gate 			 port map (x=>or1,y=>or0,z=>hit);
    	
    	--output 
	mux0_map:	mux_n generic map (n=>2070)	 port map (sel=>selectSid(0), src0=>input_0, src1=>input_1, z=>mux0);
	mux1_map:	mux_n generic map (n=>2070)	 port map (sel=>selectSid(0), src0=>input_2, src1=>input_3, z=>mux1);
	mux2_map:	mux_n generic map (n=>2070)	 port map (sel=>selectSid(1), src0=>mux0, src1=>mux1, z=>output);
	
end architecture structural;

