-- Level 1 Cache

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity L1 is 
   port 
       (
       Data_In: in std_logic_vector ( 31 downto 0);
       L2_Block_In : in std_logic_vector (511 downto 0);
       Address: in std_logic_vector ( 31 downto 0);
       Write_Enable: in std_logic;
       Memory_Block_Data_Valid : in std_logic;
       Data_Valid_L2: in std_logic;
       Enable: in std_logic;
       clk  : in std_logic;
       L1_Hit : out std_logic;
       L1_Miss : out std_logic;
       Data_Out: out std_logic_vector ( 31 downto 0);
       Dirty_Bit_Evict: out std_logic;
       Data_Out_64: out std_logic_vector ( 511 downto 0)
       );
end L1;
       
architecture structural of L1 is 

component shifter_512 is
	port (
		x: 	in std_logic_vector(511 downto 0); -- 535-bit input data
		y: 	in std_logic_vector(5 downto 0);  -- Position to be shifted (activate with 1)
		z: 	out std_logic_vector(511 downto 0) -- Output
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

    signal tag_L1, current_data_tag_mem: std_logic_vector (21 downto 0);
    signal index_L1: std_logic_vector ( 3 downto 0);
    signal offset_L1, offset_inv: std_logic_vector ( 5 downto 0);
    
    signal WrEn_L1, WrEn_L1_pc, tag_match, tag_miss, h0, h1, current_dirty_status, tag_match_dff: std_logic;
    signal L1_Block_Out, L1_Block_In, L1_hit_block_In, L1_Hit_Data_In, L2_Block_In_T  : std_logic_vector ( 534 downto 0);
    signal m0, m1, m2, m3, s1, s0, L1_hit_block_In_wdt, L1_Block_In_wdt, L1_Block_shifted : std_logic_vector ( 511 downto 0);
    
    
begin 

tag_L1 <= Address ( 31 downto 10);
index_L1 <= Address (9 downto 6);
offset_L1 <= Address (5 downto 0);

--535 by 16 memory
L1_csram: csram generic map ( INDEX_WIDTH => 4, BIT_WIDTH => 535 )
                port map ( cs => '1', oe => '1', we => WrEn_L1, index => index_L1, din => L1_Block_In, dout => L1_Block_Out);

current_data_tag_mem <= L1_Block_Out(533 downto 512);
current_dirty_status <= L1_Block_Out(534);

Comparator_L1: cmp_n generic map ( n => 22 )
                     port map ( a => current_data_tag_mem, b => tag_L1, a_eq_b => tag_match); 
--output
L1_Hit <= tag_match;
L1_Miss <= tag_miss;
miss_sig_map: not_gate port map (tag_match, tag_miss);
evicting_dirty_bit_map: and_gate port map (current_dirty_status, WrEn_L1_pc, Dirty_Bit_Evict); 

--When to write
hitmap0: and_gate port map ( tag_miss, Data_Valid_L2, h0);
hitmap1: and_gate port map ( tag_match, Write_Enable, h1);
hitmap2: or_gate port map ( h0, h1, WrEn_L1_pc);

--clocking write as well as making sure dirty bit is cleared first.
--clockingL1_write: dffr_a port map (clk, Enable, current_dirty_status, '0', WrEn_L1_pc, '1', WrEn_L1);
clockingL1_write: syncboss port map (clk, WrEn_L1_pc, Enable, WrEn_L1);
--WrEn_L1 <= WrEn_L1_pc;

--WrEn_L1 means we have to write to L1

--Write Hit

--Get Data_In in right offset position for data write

s0 <= "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & Data_In;
s1 <= "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & "11111111111111111111111111111111";

L1_shift_535_map0: shifter_512 port map ( s0, offset_L1, m0);
L1_shift_535_map1: shifter_512 port map ( s1, offset_L1, m1);
not_mask_map: not_gate_n generic map (n=>512) port map ( m1, m2 );
and_map_L1: and_gate_n generic map (n=>512) port map (m2, L1_Block_Out (511 downto 0), m3);
or_map_L1: or_gate_n generic map (n=>512) port map (m3, m0, L1_hit_block_In_wdt);


--Choose the right source for data-in for L1 memory with appropriate dirty bit set
L2_Block_In_T <= '0' & tag_L1 & L2_Block_In;
L1_Hit_Data_In <= '1' & tag_L1 & L1_hit_block_in_wdt;
L1_data_in_mux_map: mux_n generic map (n => 535) port map ( tag_match_dff, L2_Block_In_T, L1_Hit_Data_In, L1_Block_In);
tag_match_store: dff port map (clk, tag_match, tag_match_dff);

--Get the 32 bit data from 64 byte data
offset_inv_map: not_gate_n generic map ( n=> 6) port map (offset_L1, offset_inv);
L1_shifter_map3: shifter_512 port map ( L1_Block_Out(511 downto 0), offset_inv, L1_Block_shifted);

--Output is only 32 bits
Data_Out <= L1_Block_shifted(511 downto 480);

end architecture structural; 