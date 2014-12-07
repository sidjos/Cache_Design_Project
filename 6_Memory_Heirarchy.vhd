-- top level

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity memory_hierarchy is
    
generic (
--mem_file is used to initialize your main memory. 
mem_file: string
); 
port (
--clock
clk: in std_logic;
--means the inputs are ready in the coming rising edge. 
EN: in std_logic;
--means the next request is a write request.
WR: in std_logic;
--Addr is the address of the request.
Addr: in std_logic_vector(31 downto 0);
--DataIn is the data to be written. It is only valid when the request is a write request.
DataIn: in std_logic_vector(31 downto 0);
--Ready = means your cache have finish the current request. Before you rise Ready to 1, 
--your cache should either finished the write request, or you have get the data of the read request at DataOut port.
Ready: out std_logic;
--DataOut is the data for read requests. 
DataOut: out std_logic_vector(31 downto 0);

--Below are the counters of your caches. 
l1_hit_cnt: out std_logic_vector(31 downto 0); 
l1_miss_cnt: out std_logic_vector(31 downto 0); 
l1_evict_cnt: out std_logic_vector(31 downto 0)
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
       Data_Valid_L2: in std_logic;
       Enable: in std_logic;
       clk: in std_logic;
       L1_Hit: out std_logic;
       L1_Miss: out std_logic;
       Dirty_Bit_Evict: out std_logic;
       Data_Out: out std_logic_vector ( 31 downto 0)
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
		clk:     		in std_logic; 
		reset:		in std_logic; 
		address:		in std_logic_vector(31 downto 0); 
		L2_Miss: 	in std_logic;
		main_write: 	in std_logic;
		data_in: 	in std_logic_vector (31 downto 0);
		data_valid: 	out std_logic;
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
    sync: out std_logic
    );
end component;

signal L2_Block_Out: std_logic_vector ( 511 downto 0);
signal Dirty_Bit_Evict, L2_Data_Valid, memory_data_valid, L2_Hit, L1_Hit, L1_Miss, L2_Miss, L1_Hit_sync, L1_Miss_sync, L2_Miss_sync, L2_Hit_sync: std_logic; 
signal Memory_Block_In: std_logic_vector (2069 downto 0);


begin


ready_signal_map: syncboss port map (clk, L1_Hit, Ready);
L1_Hit_Count_s: syncboss port map (clk, L1_Hit, L1_Hit_sync);
L1_Miss_Count_s: syncboss port map (clk, L1_Miss, L1_Miss_sync);
L2_Hit_Count_s: syncboss port map (clk, L2_Hit, L2_Hit_sync);
L2_Miss_Count_s: syncboss port map (clk, L2_Miss, L2_Miss_sync);

L1_Hit_Counter: Counter_S port map ('1', L1_Hit_sync, '0', l1_hit_cnt);
L1_Miss_Counter: Counter_S port map ('1', L1_Miss_sync, '0', l1_miss_cnt);
L1_Evict_Counter: Counter_S port map ('1', Dirty_Bit_Evict, '0', l1_evict_cnt);

L1_map: L1 port map
       (
       Data_In=>DataIn,
       L2_Block_In=>L2_Block_Out,
       Address=>Addr,
       Write_Enable=>WR,
       Data_Valid_L2=>L2_Data_Valid,
       Enable=>EN,
       clk =>clk,
       L1_Hit=>L1_Hit,
       L1_Miss=> L1_Miss,
       Dirty_Bit_Evict => Dirty_Bit_Evict,
       Data_Out=>DataOut
       );

L2_map: L2 port map(
       Data_In => DataIn,
       Memory_Block_In=>Memory_Block_In ,
       Address=>Addr,
       Write_Enable=> WR,
       Memory_Block_Data_Valid=>memory_data_valid,
       Data_Valid_L2=>L2_Data_Valid,
       Enable=>EN,
       clk =>clk,
       L2_Hit=>L2_Hit,
       L2_Miss=>L2_Miss,
       L2_Data_Out=>L2_Block_Out
       );

mainMemoryMap: main_memory generic map ( mem_file => mem_file )
	port map (
		clk=>    clk,
		reset =>		EN,
		address =>	Addr, 
		L2_Miss=>	L2_miss,
		main_write=>		WR,
		data_in=>	DataIn,
		data_valid=>	memory_data_valid,
		data_out_with_tag=>	Memory_Block_In
	);

end structural;
