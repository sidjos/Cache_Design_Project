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
       Main_Memory_Write_Valid: in std_logic;
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
		hit:		out std_logic;
		comp:	out std_logic_vector(3 downto 0)
	);
end component;

component syncboss is 
port(
    clk     : in std_logic;
    b: in std_logic;
    Enable: in std_logic;
    sync: out std_logic
    );
end component;

component lru_counter_to_offset_s is
  port ( 
    Update : in std_logic;
    Rd     : in std_logic_vector(3 downto 0);
    Wr     : in std_logic_vector(3 downto 0);
    Reset  : in std_logic;
    Wr_o   : out std_logic_vector(3 downto 0)
    );
  end component;
  
component lru_counter_to_offset_s is
  port ( 
    Update : in std_logic;
    Rd     : in std_logic_vector(3 downto 0);
    Wr     : in std_logic_vector(3 downto 0);
    Reset  : in std_logic;
    Wr_o   : out std_logic_vector(3 downto 0)
    );
  end component;

    signal tag_L2 : std_logic_vector (21 downto 0);
    signal index_L2: std_logic_vector ( 1 downto 0);
    signal offset_L2, offset_inv: std_logic_vector ( 7 downto 0);
    
    signal set_read, set_written, set_to_be_written: std_logic_vector(3 downto 0);
    
    signal update, WrEn_L2, WrEn_L2_s0_pc, WrEn_L2_s1_pc, WrEn_L2_s2_pc, WrEn_L2_s3_pc, WrEn_L2_s0, WrEn_L2_s1, WrEn_L2_s2, WrEn_L2_s3, L2_tag_match,L2_tag_miss, h0, h1 : std_logic;
    signal L2_Block_Out_s0, L2_Block_Out_s1, L2_Block_Out_s2, L2_Block_Out_s3, tag, L2_block_Out, L2_Block_In  : std_logic_vector ( 2069 downto 0);
    signal b0, b1, b2, b3, m0, m1 : std_logic_vector (511 downto 0);
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

L2_output_current: tag_L2_compare port map ( L2_Block_Out_s0, L2_Block_Out_s1, L2_Block_Out_s2, L2_Block_Out_s3, tag_L2, L2_block_Out, L2_tag_match, set_read);
miss_sig_map_L2: not_gate port map (L2_tag_match, L2_tag_miss);

--output
L2_hit <= L2_tag_match;
L2_Miss <= L2_tag_miss;
Data_Valid_L2 <= L2_tag_match;

--Need to split L2_Block_Out to generate output for L1

b0 <= L2_Block_Out( 511 downto 0);
b1 <= L2_Block_Out( 1023 downto 512);
b2 <= L2_Block_Out( 1535 downto 1024);
b3 <= L2_Block_Out( 2047 downto 1536);
 
muxL2_0: mux_n generic map (n=>512) port map ( offset_L2(6), b0, b1, m0);
muxL2_1: mux_n generic map (n=>512) port map ( offset_L2(6), b2, b3, m1);
muxL2_2: mux_n generic map (n=>512) port map ( offset_L2(7), m0, m1, L2_Data_Out);


--When to write
hitmap0: and_gate port map ( L2_tag_miss, Memory_Block_Data_Valid, h0);
hitmap1: and_gate port map ( L2_tag_match, Write_Enable, h1);
hitmap2: or_gate port map ( h0, h1, WrEn_L2);
--hitmap3: or_gate port map (WrEn_L2_pc, Main_Memory_Write_Valid, WrEn_L2);
--WrEn_L2 means we have to write L2 memory


--------------------------------
--Where to write/ LRU Implementation
--WrEn_L2_s0_pc <= WrEn_L2;

--set_written <= "0000";

WrEn_L2_s0_pc <= set_to_be_written(0);
WrEn_L2_s1_pc <= set_to_be_written(1);
WrEn_L2_s2_pc <= set_to_be_written(2);
WrEn_L2_s3_pc <= set_to_be_written(3);

update_LRU_map: or_gate port map (L2_tag_match, WrEn_L2, update);
LRU_Map: lru_counter_to_offset_s port map ( update, set_read, set_to_be_written, Enable, set_to_be_written);

--Initialize LRU here and comment the above line. Whatever output the LRU is giving, AND it with
--WrEn_L2 and we will have the write signals for the four sets. 
--------------------------------


--Clocking Write

clockingL2_write0: syncboss port map (clk, WrEn_L2_s0_pc, Enable, WrEn_L2_s0);
clockingL2_write1: syncboss port map (clk, WrEn_L2_s1_pc, Enable, WrEn_L2_s1);
clockingL2_write2: syncboss port map (clk, WrEn_L2_s2_pc, Enable, WrEn_L2_s2);
clockingL2_write3: syncboss port map (clk, WrEn_L2_s3_pc, Enable, WrEn_L2_s3);

--What to write
L2_Block_In <= Memory_Block_In;

end structural; 