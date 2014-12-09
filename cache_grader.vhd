library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.cache_test;

entity cache_grader is
end cache_grader;

architecture mix of cache_grader is
component memory_hierarchy is
  generic (
    mem_file : string
  );
  port (
    clk : in std_logic;
    EN : in std_logic;
    WR : in std_logic;
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
end component memory_hierarchy;
signal clk : std_logic := '0';
signal rst : std_logic;
signal en : std_logic;
signal wr : std_logic;
signal addr : std_logic_vector(31 downto 0);
signal datain : std_logic_vector(31 downto 0);
signal dataout : std_logic_vector(31 downto 0);
signal ready : std_logic;
signal err : std_logic;
signal l1h, l1m, l1e, l2h, l2m, l2e : std_logic_vector(31 downto 0);
begin
  clk <= not clk after 5 ns;
  rst <= '1', '0' after 2 ns;
  en <= '0' , '1' after 7 ns;

  mem_map : memory_hierarchy
    generic map (
      mem_file => "data/mem_init"
    )
    port map (
      clk => clk,
      EN => en,
      WR => wr,
      Addr => addr,
      DataIn => datain,
      Ready => ready,
      DataOut => dataout,
      l1_hit_cnt => l1h,
      l1_miss_cnt => l1m,
      l1_evict_cnt => l1e,
      l2_hit_cnt => l2h,
      l2_miss_cnt => l2m,
      l2_evict_cnt => l2e
    );

  tester_map : cache_test
    generic map (
      data_trace_file => "data/readonly_data_trace",
      addr_trace_file => "data/readonly_addr_trace"
    )
    port map (
      DataIn => dataout,
      clk => clk,
      Ready => ready,
      rst => rst,
      Addr => addr,
      Data => datain,
      WR => wr,
      Err => err
    );

  err_proc : process(err)
  begin
    if err = '1' then
      report "ERROR: Err = '1'";
    end if;
  end process;
end architecture mix;
