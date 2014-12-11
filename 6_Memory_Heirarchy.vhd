-- top level

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity memory_hierarchy is
  generic (
    mem_file : string
  );
  port (
    clk : in std_logic;
    EN : in std_logic;
    WR : in std_logic;
    rst : in std_logic;
    Addr : in std_logic_vector(31 downto 0);
    DataIn : in std_logic_vector(31 downto 0);
    Ready : out std_logic;
    DataOut : out std_logic_vector(31 downto 0);
    l1_hit_cnt : out std_logic_vector(31 downto 0);
    l1_miss_cnt : out std_logic_vector(31 downto 0);
    l1_evict_cnt : out std_logic_vector(31 downto 0);
    l2_hit_cnt : out std_logic_vector(31 downto 0);
    l2_miss_cnt : out std_logic_vector(31 downto 0);
    l2_evict_cnt : out std_logic_vector(31 downto 0)
  );
end memory_hierarchy;

architecture structural of memory_hierarchy is
    
component L1 is 
   port 
       (
       Data_In: in std_logic_vector ( 31 downto 0);
       L2_Block_In: in std_logic_vector (511 downto 0);
       Address: in std_logic_vector ( 31 downto 0);
       Write_Enable: in std_logic;
       Memory_Valid_Write: in std_logic;
       Memory_Block_Data_Valid : in std_logic;
       Data_Valid_L2: in std_logic;
       Enable: in std_logic;
       clk: in std_logic;
       L1_Hit: out std_logic;
       L1_Miss: out std_logic;
       Dirty_Bit_Evict: out std_logic;
       Data_Out: out std_logic_vector ( 31 downto 0);
       Data_Out_64: out std_logic_vector ( 511 downto 0);
       Write_Main_Memory: out std_logic
       );
end component;

component L2 is 
   port 
       (
       Data_In: in std_logic_vector ( 31 downto 0);
       Memory_Block_In: in std_logic_vector (2069 downto 0);
       Address: in std_logic_vector ( 31 downto 0);
       Write_Enable: in std_logic;
       Memory_Block_Data_Valid: in std_logic;
       Main_Memory_Write_Valid: in std_logic;
       Data_Valid_L2: out std_logic;
       Enable: in std_logic;
       clk: in std_logic;
       L2_Hit: out std_logic;
       L2_Miss: out std_logic;
       L2_Data_Out: out std_logic_vector ( 511 downto 0)
       );
end component;

	
component main_memory is
	generic ( mem_file: string);
	port (
		clk:     	in std_logic; 
		reset:		in std_logic; 
		address:	in std_logic_vector(31 downto 0); 
		L2_Miss: 	in std_logic; --reading
		main_write: 	in std_logic; --writing
		data_in: 	in std_logic_vector (511 downto 0);
		data_valid_read: 	out std_logic;
		data_valid_write: 	out std_logic;
		data_out_with_tag: 	out std_logic_vector(2069 downto 0)
	);
end component;

component Counter_s is
  port (
    FA_1or0   : in std_logic;
    Clk_ip    : in std_logic;
    Reset     : in std_logic;
    FA_ip_op   : out std_logic_vector(31 downto 0)
    );
end component;

component syncboss is 
port(
    clk: in std_logic;
    b: in std_logic;
    Enable: in std_logic;
    sync: out std_logic
    );
end component;

signal L2_Block_Out, Data_L1: std_logic_vector ( 511 downto 0);
signal Write_Main_Memory, L1_Hit_Store, Ready_Sig_Comp, Memory_Write_Complete, Dirty_Bit_Evict,EN_C, Reset_for_Main_Memory, Ready_Sig, L2_Data_Valid, memory_data_valid, L2_Hit, L1_Hit, L1_Miss, L2_Miss, L1_Hit_sync, L1_Miss_sync, L2_Miss_sync, L2_Hit_sync: std_logic; 
signal Memory_Block_In: std_logic_vector (2069 downto 0);


begin

ready_signal_map: syncboss port map (clk, L1_Hit_Store,EN_C , Ready_Sig);
Ready <= Ready_Sig; 
ready_comp_map: not_gate port map (Reset_for_Main_Memory, Ready_Sig_Comp);

L1_Hit_Count_s: syncboss port map (Ready_Sig_Comp, L1_Hit, EN_C, L1_Hit_sync);
L1_Miss_Count_s: syncboss port map (Ready_Sig_Comp, L1_Miss, EN_C, L1_Miss_sync);
L2_Hit_Count_s: syncboss port map (Ready_Sig_Comp, L2_Hit, EN_C, L2_Hit_sync);
L2_Miss_Count_s: syncboss port map (Ready_Sig_Comp, L2_Miss, EN_C, L2_Miss_sync);

enable_comp: not_gate port map (EN, EN_C);
Reset_Main_MeM_MAP: or_gate port map (rst, Ready_Sig, Reset_for_Main_Memory);
L1_Hit_Store_Map: dffr_a port map (clk, Ready_Sig, '0', '0', L1_Hit, '1', L1_Hit_Store);

L1_Hit_Counter: Counter_S port map (L1_Hit, Ready_Sig_Comp, rst, l1_hit_cnt);
L1_Miss_Counter: Counter_S port map (L1_Miss, Ready_Sig_Comp, rst, l1_miss_cnt);
L1_Evict_Counter: Counter_S port map (Dirty_Bit_Evict, Ready_Sig_Comp, rst, l1_evict_cnt);
L2_Hit_Counter: Counter_S port map (L2_Hit, Ready_Sig_Comp, rst, l2_hit_cnt);
L2_Miss_Counter: Counter_S port map (L2_Miss, Ready_Sig_Comp, rst, l2_miss_cnt);
L2_Evict_Counter: Counter_S port map (memory_write_complete, Ready_Sig_Comp, rst, l2_evict_cnt);


L1_map: L1 port map
       (
       Data_In=>DataIn,
       L2_Block_In=>L2_Block_Out,
       Address=>Addr,
       Write_Enable=>WR,
       Memory_valid_write=> memory_write_complete,
       Memory_Block_Data_Valid => memory_data_valid,
       Data_Valid_L2=>L2_Data_Valid,
       Enable=>EN_C,
       clk =>clk,
       L1_Hit=>L1_Hit,
       L1_Miss=> L1_Miss,
       Dirty_Bit_Evict => Dirty_Bit_Evict,
       Data_Out=>DataOut,
       Data_Out_64 => Data_L1,
       Write_Main_Memory => Write_Main_Memory
       );

L2_map: L2 port map(
       Data_In => DataIn,
       Memory_Block_In=>Memory_Block_In ,
       Address=>Addr,
       Write_Enable=> WR,
       Memory_Block_Data_Valid=>memory_data_valid,
       Main_Memory_Write_Valid => memory_write_complete,
       Data_Valid_L2=>L2_Data_Valid,
       Enable=>EN_C,
       clk =>clk,
       L2_Hit=>L2_Hit,
       L2_Miss=>L2_Miss,
       L2_Data_Out=>L2_Block_Out
       );
 
mainMemoryMap: main_memory generic map ( mem_file => mem_file )
	port map (
		clk=>    clk,
		reset =>		Reset_for_Main_Memory,
		address =>	Addr, 
		L2_Miss=>	L2_miss,
		main_write=> Write_Main_Memory,
		data_in=>	Data_L1,
		data_valid_read=>	memory_data_valid,
		data_valid_write=> memory_write_complete,
		data_out_with_tag=>	Memory_Block_In
	);


end structural;
