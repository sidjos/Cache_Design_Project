-- top level

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity memory_hierarchy is
    
generic (
--mem_file is used to initialize your main memory. 
mem_file : string
); 
port (
--clock
clk : in std_logic;
--means the inputs are ready in the coming rising edge. 
EN : in std_logic;
--means the next request is a write request.
WR : in std_logic;
--Addr is the address of the request.
Addr : in std_logic_vector(31 downto 0);
--DataIn is the data to be written. It is only valid when the request is a write request.
DataIn : in std_logic_vector(31 downto 0);
--Ready = means your cache have finish the current request. Before you rise Ready to 1, 
--your cache should either finished the write request, or you have get the data of the read request at DataOut port.
Ready : out std_logic;
--DataOut is the data for read requests. 
DataOut : out std_logic_vector(31 downto 0);

--Below are the counters of your caches. 
l1_hit_cnt : out std_logic_vector(31 downto 0); 
l1_miss_cnt : out std_logic_vector(31 downto 0); 
l1_evict_cnt : out std_logic_vector(31 downto 0)
);
end memory_hierarchy;

architecture structual of memory_heirarchy is
    
component L1 is 
   port 
       (
       Data_In: in std_logic_vector ( 31 downto 0);
       L2_Block_In : in std_logic_vector (511 downto 0);
       Address: in std_logic_vector ( 31 downto 0);
       Write_Enable: in std_logic;
       Data_Valid_L2: in std_logic;
       Enable: in std_logic;
       clk  : in std_logic;
       Hit : out std_logic;
       Data_Out: out std_logic_vector ( 31 downto 0)
       );
end L1;

component L2 is 
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
       L2_Data_Out: out std_logic_vector ( 511 downto 0)
       );
end L2;

component main_memory is
	generic ( memfile_s: string);
	port (
		rst	in std_logic; 
		addr	in std_logic_vector(31 downto 0); 
		x: 	in std_logic_vector(511 downto 0); -- 512-bit input data
		y: 	in std_logic_vector(5 downto 0);  -- Position to be shifted (activate with 1)
		z: 	out std_logic_vector(511 downto 0); -- Output
		data_valid: out std_logic
	);
end main_memory;

component syncboss is 
port(
    clk     : in std_logic;
    b: in std_logic;
    sync: out std_logic
    );
end syncboss;

begin



















L1_map: L1 
   port map
       (
       Data_In: DataIn;
       L2_Block_In : in std_logic_vector (511 downto 0);
       Address: Addr;
       Write_Enable: WR;
       Data_Valid_L2: in std_logic;
       Enable: EN;
       clk  : clk;
       Hit : L1_Hit;
       Data_Out: DataOut
       );
end L1;

L2_map: L2 port map 
       (
       Data_In: DataIn;
       Memory_Block_In : Memory_Block_In (2069 downto 0);
       Address: Addr;
       Write_Enable: WR;
       Memory_Block_Data_Valid: in std_logic;
       Data_Valid_L2: Data_Valid_L2;
       Enable: in std_logic;
       clk  : in std_logic;
       L2_Hit : out std_logic;
       L2_Data_Out: out std_logic_vector ( 511 downto 0)
       );
end L2;

component main_memory is
	generic ( memfile_s: string);
	port (
		rst	in std_logic; 
		addr	in std_logic_vector(31 downto 0); 
		x: 	in std_logic_vector(511 downto 0); -- 512-bit input data
		y: 	in std_logic_vector(5 downto 0);  -- Position to be shifted (activate with 1)
		z: 	out std_logic_vector(511 downto 0); -- Output
		data_valid: out std_logic
	);
end main_memory;