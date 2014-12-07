library IEEE;
use IEEE.std_logic_1164.all; -- std_logic
--Additional standard or custom libraries go here
entity lru_counter_tb is
  port (
    F_tb : out std_logic_vector(31 downto 0)
  );
end entity lru_counter_tb;

architecture behavioral of lru_counter_tb is
--Entity (as component) and input ports (as signals) go here
component lru_counter_s is
  port (
    Update    : in std_logic;
    Rd        : in std_logic;
    Wr        : in std_logic;
    Reset     : in std_logic;
    Counter   : out std_logic_vector(31 downto 0)
    );
end component lru_counter_s;
--component declaration and stimuli processes go here
  signal update_s, Rd_s, Wr_s, Reset_s: std_logic := '0';

begin 
  DUT : lru_counter_s
    port map(update_s, Rd_s, Wr_s, Reset_s, F_tb);

    simulate_all : process is
    begin 
      Reset_s <= '1';
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      Reset_s <= '0'; 

      Wr_s <= '0'; Rd_s <= '0'; 
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      Wr_s <= '1'; Rd_s <= '0'; 
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      Wr_s <= '0'; Rd_s <= '1'; 
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      Wr_s <= '1'; Rd_s <= '1'; 
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      
      Wr_s <= '0'; Rd_s <= '0'; 

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;                              
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;                              

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;

      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;      
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      update_s <= '0'; wait for 5 ns; update_s <= '1'; wait for 5 ns;
      wait;
    end process simulate_all;
end architecture behavioral;
