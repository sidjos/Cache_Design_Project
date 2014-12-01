library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.eecs361.sram;

entity cache_test is
  generic (
    addr_trace_file : string;
    data_trace_file : string
  );
  port (
    DataIn : in std_logic_vector(31 downto 0);
    clk : in std_logic;
    Ready : in std_logic;
    rst : in std_logic;
    Addr : out std_logic_vector(31 downto 0);
    Data : out Std_logic_vector(31 downto 0);
    WR : out std_logic;
    Err : out std_logic
  );
end cache_test;

architecture mix of cache_test is
signal addr_src : std_logic_vector(31 downto 0);
signal addr_trace : std_logic_vector(31 downto 0);
signal data_trace : std_logic_vector(31 downto 0);
signal cmp : std_logic;
begin
  addr_proc : process(clk, rst)
  begin
    if rst = '1' then
      addr_src <= (others => '0');
    elsif rising_edge(clk) then
      if Ready = '1' then
        addr_src <= std_logic_vector(4 + unsigned(addr_src));
      end if;
    end if;
  end process;

  addr_trace_map : sram
    generic map ( mem_file => addr_trace_file )
    port map (
      cs    => '1',
      oe    => '1',
      we    => '0',
      addr  => addr_src,
      din   => (others => '0'),
      dout  => addr_trace
    );
    
  data_trace_map : sram
    generic map ( mem_file => data_trace_file )
    port map (
      cs    => '1',
      oe    => '1',
      we    => '0',
      addr  => addr_src,
      din   => (others => '0'),
      dout  => data_trace
    );

  Addr <= '0' & addr_trace(30 downto 0);
  Data <= data_trace when (addr_trace(31) = '1')
     else (others => '0');
  WR <= addr_trace(31);
  cmp <= '1' when DataIn = data_trace else '0';
  process(clk)
  begin
    if rising_edge(clk) then
      Err <= Ready and (not addr_trace(31)) and (not cmp) and (not rst);
    end if;
  end process;
end mix;
