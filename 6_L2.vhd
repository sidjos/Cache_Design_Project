-- Level 2 Cache

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity L2 is 
   port 
       (
       Data_In: in std_logic_vector ( 31 downto 0);
       Memory_Block_In : in std_logic_vector (2069 downto 0);
       Address: in std_logic_vector ( 31 downto 0);
       Write_Enable: in std_logic;
       Memory_Block_Data_Valid: in std_logic;
       Data_Valid_L2: out std_logic;
       Enable: in std_logic;
       clk  : in std_logic;
       L2_Hit : out std_logic;
       L2_Miss: out std_logic;
       L2_Data_Out: out std_logic_vector ( 511 downto 0)
       );
end L2;

architecture structural of L2 is 

component shifter_512 is
	port (
		x: 	in std_logic_vector(511 downto 0); -- 535-bit input data
		y: 	in std_logic_vector(5 downto 0);  -- Position to be shifted (activate with 1)
		z: 	out std_logic_vector(511 downto 0) -- Output
	);
end component;

component tag_L2_compare is
	port (
		input_0: 	in std_logic_vector(2069 downto 0); -- 22-bit tag + 256 bytes
		input_1: 	in std_logic_vector(2069 downto 0); 
		input_2: 	in std_logic_vector(2069 downto 0); 
		input_3:	in std_logic_vector(2069 downto 0);
		tag:		in std_logic_vector(21 downto 0);
		output:		out std_logic_vector(2069 downto 0);
		hit:		out std_logic
	);
end component;

    signal tag_L2 : std_logic_vector (21 downto 0);
    signal index_L2: std_logic_vector ( 1 downto 0);
    signal offset_L2, offset_inv: std_logic_vector ( 7 downto 0);
    
    signal WrEn_L2, WrEn_L2_s0_pc, WrEn_L2_s1_pc, WrEn_L2_s2_pc, WrEn_L2_s3_pc, WrEn_L2_s0, WrEn_L2_s1, WrEn_L2_s2, WrEn_L2_s3, L2_tag_match, h0, h1 : std_logic;
    signal L2_Block_Out_s0, L2_Block_Out_s1, L2_Block_Out_s2, L2_Block_Out_s3, tag, L2_block_Out, L2_Block_In  : std_logic_vector ( 2069 downto 0);
    signal m0, m1: std_logic_vector (2047 downto 0);
 --   signal m0, m1, m2, m3, s1, s0, L1_hit_block_In_wdt, L1_Block_In_wdt, L1_Block_shifted : std_logic_vector ( 511 downto 0);
    
    
begin 

tag_L2 <= Address ( 31 downto 10);
index_L2 <= Address (9 downto 8);
offset_L2 <= Address (7 downto 0);

L2_csram_s0: csram generic map ( INDEX_WIDTH => 2, BIT_WIDTH => 2070 )
                port map ( cs => '1', oe => '1', we => WrEn_L2_s0, index => index_L2, din => L2_Block_In, dout => L2_Block_Out_s0);
                    
L2_csram_s1: csram generic map ( INDEX_WIDTH => 2, BIT_WIDTH => 2070 )
                port map ( cs => '1', oe => '1', we => WrEn_L2_s1, index => index_L2, din => L2_Block_In, dout => L2_Block_Out_s1);
                    
L2_csram_s2: csram generic map ( INDEX_WIDTH => 2, BIT_WIDTH => 2070 )
                port map ( cs => '1', oe => '1', we => WrEn_L2_s2, index => index_L2, din => L2_Block_In, dout => L2_Block_Out_s2);

L2_csram_s3: csram generic map ( INDEX_WIDTH => 2, BIT_WIDTH => 2070 )
                port map ( cs => '1', oe => '1', we => WrEn_L2_s3, index => index_L2, din => L2_Block_In, dout => L2_Block_Out_s3);


--Comparators

L2_output_current: tag_L2_compare port map ( L2_Block_Out_s0, L2_Block_Out_s1, L2_Block_Out_s2, L2_Block_Out_s3, tag_L2, L2_block_Out, L2_tag_match);
miss_sig_map_L2: not_gate port map (L2_tag_match, L2_miss);

--output
L2_hit <= L2_tag_match;

--Need to split L2_Block_Out
muxL2_0: mux_n generic map (n=>2048) port map ( L2_Block_Out( 511 downto 0), L2_Block_Out( 1023 downto 512), m0);
muxL2_1: mux_n generic map (n=>2048) port map ( L2_Block_Out( 1535 downto 1024), L2_Block_Out( 2047 downto 1536), m1);
muxL2_2: mux_n generic map (n=>2048) port map ( m0, m1, L2_Data_Out);


--When to write
hitmap0: and_gate port map ( L2_miss, Memory_Block_Data_Valid, h0);
hitmap1: and_gate port map ( L2_tag_match, Write_Enable, h1);
hitmap2: or_gate port map ( h0, h1, WrEn_L2);
--Clocking Write
clockingL2_write: dffr_a port map (clk, Enable, '0', '0', WrEn_L2_s0_pc, '1', WrEn_L2_s0);
--WrEn_L2 means we have to write L2 memory

--Where to write
WrEn_L2_s0_pc <= WrEn_L2; -- have to implement LRU

--What to write
L2_Block_In <= Memory_Block_In; --implement mux

end structural; 