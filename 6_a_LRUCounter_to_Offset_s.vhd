library IEEE;
use IEEE.std_logic_1164.all; -- std_logic

entity lru_counter_to_offset_s is
  port ( 
    Update : in std_logic;
    Rd     : in std_logic_vector(3 downto 0);
    Wr     : in std_logic_vector(3 downto 0);
    Reset  : in std_logic;
    Clock  : in std_logic;
    Wr_o   : out std_logic_vector(3 downto 0)
    );
  end lru_counter_to_offset_s;

  architecture lru_counter_to_offset_str of lru_counter_to_offset_s is
    signal counter_s_0, counter_s_1, counter_s_2, counter_s_3 : std_logic_vector(31 downto 0);
    signal Wr_gs, Wr_ns : std_logic_vector(3 downto 0);
    signal offset_s : std_logic_vector(1 downto 0);
    signal reset_ns : std_logic;

begin 
  lru_c_0 : entity work.lru_counter_s 
    port map(Update, Rd(0), Wr(0), Reset, counter_s_0);

  lru_c_1 : entity work.lru_counter_s 
    port map(Update, Rd(1), Wr(1), Reset, counter_s_1);

  lru_c_2 : entity work.lru_counter_s 
    port map(Update, Rd(2), Wr(2), Reset, counter_s_2);

  lru_c_3 : entity work.lru_counter_s 
    port map(Update, Rd(3), Wr(3), Reset, counter_s_3);

  com_4toOffset_0 : entity work.com_4toOffset_s
    port map(counter_s_0, counter_s_1, counter_s_2, counter_s_3, offset_s);

  not_reset_inv : entity work.not_gate
    port map(Reset, reset_ns);

  dec_0 : entity work.dec_n
    generic map(n => 2)
    port map(offset_s, Wr_ns);

-- glitch elimination and does not work
--  and_glich_0 : entity work.and_gate
--    port map(Clock, Wr_ns(0), Wr_gs(0));
--
--  and_glich_1 : entity work.and_gate
--    port map(Clock, Wr_ns(1), Wr_gs(1));
--
--  and_glich_2 : entity work.and_gate
--    port map(Clock, Wr_ns(2), Wr_gs(2));
--
--  and_glich_3 : entity work.and_gate
--    port map(Clock, Wr_ns(3), Wr_gs(3));
  dffr_glitch_0 : entity work.dffr_a
    port map(Clock, Reset, '0', '0', Wr_ns(0), '1', Wr_gs(0));

  dffr_glitch_1 : entity work.dffr_a
    port map(Clock, Reset, '0', '0', Wr_ns(1), '1', Wr_gs(1));

  dffr_glitch_2 : entity work.dffr_a
    port map(Clock, Reset, '0', '0', Wr_ns(2), '1', Wr_gs(2));
    
  dffr_glitch_3 : entity work.dffr_a
    port map(Clock, Reset, '0', '0', Wr_ns(3), '1', Wr_gs(3));            
-- glitch elimination

  and_resetn_0 : entity work.and_gate
    port map(reset_ns, Wr_gs(0), Wr_o(0));

  and_resetn_1 : entity work.and_gate
    port map(reset_ns, Wr_gs(1), Wr_o(1));

  and_resetn_2 : entity work.and_gate
    port map(reset_ns, Wr_gs(2), Wr_o(2));

  and_resetn_3 : entity work.and_gate
    port map(reset_ns, Wr_gs(3), Wr_o(3));        
    
end architecture lru_counter_to_offset_str;