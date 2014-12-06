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
       Memory_Block_In : in std_logic_vector (1023 downto 0);
       Address: in std_logic_vector ( 31 downto 0);
       Write_Enable: in std_logic;
       Data_Valid_L2: out std_logic;
       clk  : in std_logic;
       L2_Hit : out std_logic;
       L2_Data_Out: out std_logic_vector ( 511 downto 0)
       );
end L1;

architecture structural of L1 is 
 
 component csram is
      generic (
        INDEX_WIDTH : integer;
        BIT_WIDTH : integer
      );
      port (
       cs	  : in	std_logic;
       oe	  :	in	std_logic;
       we	  :	in	std_logic;
       index : in	std_logic_vector(INDEX_WIDTH-1 downto 0);
       din	  :	in	std_logic_vector(BIT_WIDTH-1 downto 0);
       dout  :	out std_logic_vector(BIT_WIDTH-1 downto 0)
      );
    end component;
    
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

component cmp_n is
  generic (
    n : integer
  );
  port (
    a      : in std_logic_vector(n-1 downto 0);
    b      : in std_logic_vector(n-1 downto 0);

    a_eq_b : out std_logic;
    a_gt_b : out std_logic;
    a_lt_b : out std_logic;

    signed_a_gt_b : out std_logic;
    signed_a_lt_b : out std_logic
  );
end component;

    signal tag_L1, current_data_tag_mem: std_logic_vector (21 downto 0);
    signal index_L1: std_logic_vector ( 3 downto 0);
    signal offset_L1, offset_inv: std_logic_vector ( 5 downto 0);
    
    signal WrEn_L1, tag_match, h0, h1, miss, current_dirty_status: std_logic;
    signal L2_Block_Out, L2_Block_In  : std_logic_vector ( 534 downto 0);
 --   signal m0, m1, m2, m3, s1, s0, L1_hit_block_In_wdt, L1_Block_In_wdt, L1_Block_shifted : std_logic_vector ( 511 downto 0);
    
    
begin 

tag_L1 <= Address ( 31 downto 10);
index_L1 <= Address (9 downto 6);
offset_L1 <= Address (5 downto 0);

L2_csram: csram generic map ( INDEX_WIDTH => 4, BIT_WIDTH =>  )
                port map ( cs => '1', oe => '1', we => WrEn_L1, index => index_L1, din => L1_Block_In, dout => L1_Block_Out);

current_data_tag_mem <= L1_Block_Out(533 downto 512);
current_dirty_status <= L1_Block_Out(534);
Comparator_L1: cmp_n generic map ( n => 22 )
                     port map ( a => current_data_tag_mem, b => tag_L1, a_eq_b => tag_match); 
--output
hit <= tag_match;

miss_sig_map: not_gate port map (tag_match, miss);

--When to write
hitmap0: and_gate port map ( miss, Data_Valid_L2, h0);
hitmap1: and_gate port map ( tag_match, Write_Enable, h1);
hitmap2: or_gate port map ( h0, h1, WrEn_L1);
--WrEn_L1 means we have to write

