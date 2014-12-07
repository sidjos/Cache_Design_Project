library IEEE;
use IEEE.std_logic_1164.all; -- std_logic

entity lru_counter_to_offset_s is
  port ( 
    Update : in std_logic;
    Rd     : in std_logic_vector(3 downto 0);
    Wr     : in std_logic_vector(3 downto 0);
    Reset  : in std_logic;
    Wr_o   : out std_logic_vector(3 downto 0)
    );
  end lru_counter_to_offset_s;

  architecture lru_counter_to_offset_str of lru_counter_to_offset_s is
    signal counter_s_0, counter_s_1, counter_s_2, counter_s_3 : std_logic_vector(31 downto 0);
    signal offset_s : std_logic_vector(1 downto 0);

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

  dec_0 : entity work.dec_n
    generic map(n => 2)
    port map(offset_s, Wr_o);
end architecture lru_counter_to_offset_str;