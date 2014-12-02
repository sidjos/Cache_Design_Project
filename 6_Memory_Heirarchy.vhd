-- top level

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity memory_hierarchy is
generic (
­­ mem_file is used to initialize your main memory. mem_file : string
); port (
­­ clock
clk : in std_logic;
­­ EN = ‘1’ means the inputs are ready in the coming rising edge. EN : in std_logic;
­­ WR = ‘1’ means the next request is a write request.
WR : in std_logic;
­­ Addr is the address of the request.
Addr : in std_logic_vector(31 downto 0);
­­ DataIn is the data to be written. It is only valid when the
request is a write request.
DataIn : in std_logic_vector(31 downto 0);
­­ Ready = ‘1’ means your cache have finish the current request.
Before you rise Ready to ‘1’, your cache should either finished the write request, or you have get the data of the read request at DataOut port.
Ready : out std_logic;
­­ DataOut is the data for read requests. DataOut : out std_logic_vector(31 downto 0);
­­ Below are the counters of your caches. l1_hit_cnt : out std_logic_vector(31 downto 0); l1_miss_cnt : out std_logic_vector(31 downto 0); l1_evict_cnt : out std_logic_vector(31 downto 0); l1_hit_cnt : out std_logic_vector(31 downto 0);
l1_miss_cnt : out std_logic_vector(31 downto 0);
l1_evict_cnt : out std_logic_vector(31 downto 0) );
end memory_hieracrchy;
